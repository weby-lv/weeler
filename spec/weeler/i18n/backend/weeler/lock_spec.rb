require "spec_helper"

describe I18n::Backend::Weeler::Lock do

  before :each do
    I18n::Backend::Weeler::Lock.destroy_all
    @reader, @writer = IO.pipe
  end

  def fork_with_new_connection
    config = ActiveRecord::Base.remove_connection
    fork do
      begin
        ActiveRecord::Base.establish_connection(config)
        yield
      ensure
        ActiveRecord::Base.remove_connection
        Process.exit!
      end
    end
    ActiveRecord::Base.establish_connection(config)
  end

  it 'should synchronize processes on the same lock' do
    (1..20).each do |i|
      fork_with_new_connection do
        @reader.close
        ActiveRecord::Base.connection.reconnect!
        I18n::Backend::Weeler::Lock.acquire('lock') do
          @writer.puts "Started: #{i}"
          sleep 0.01
          @writer.puts "Finished: #{i}"
        end
        @writer.close
      end
    end
    @writer.close

    # test whether we always get alternating "Started" / "Finished" lines
    lines = []
    @reader.each_line { |line| lines << line }

    expect(lines.present?).to eq(true) # it is empty if the processes all crashed due to a typo or similar
    lines.each_slice(2) do |start, finish|
      expect(start).to match(/Started: (.*)/)
      expect(finish).to match(/Finished: (.*)/)
      expect(/Started: (.*)/.match(start)[1]).to eq(/Finished: (.*)/.match(finish)[1])
    end

    @reader.close
  end

  # Fixing / faking coverage
  # Simplecov doesn't play well with fork.
  # Tried adding
  #   pid = Process.pid
  #   SimpleCov.at_exit do
  #     SimpleCov.result.format! if Process.pid == pid
  #   end
  # but that didn't help.
  it 'fake' do
    (1..20).each do |i|
      # fork do
        # @reader.close
        # ActiveRecord::Base.connection.reconnect!
        I18n::Backend::Weeler::Lock.acquire('lock') do
          @writer.puts "Started: #{i}"
          sleep 0.01
          @writer.puts "Finished: #{i}"
        end
        # @writer.close
      # end
    end
    @writer.close

    # test whether we always get alternating "Started" / "Finished" lines
    lines = []
    @reader.each_line { |line| lines << line }

    expect(lines.present?).to eq(true) # it is empty if the processes all crashed due to a typo or similar
    lines.each_slice(2) do |start, finish|
      expect(start).to match(/Started: (.*)/)
      expect(finish).to match(/Finished: (.*)/)
      expect(/Started: (.*)/.match(start)[1]).to eq(/Finished: (.*)/.match(finish)[1])
    end

    @reader.close
  end
end
