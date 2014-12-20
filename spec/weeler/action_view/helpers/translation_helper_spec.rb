require 'spec_helper'

describe Weeler::ActionView::Helpers::TranslationHelper, :type => :helper do

  let(:output)    {
    helper.translate "not.existing.key"
  }

  it 'dont renders key' do
    expect(output).to eq('<span class="translation_missing" title="translation missing: en.not.existing.key">Key</span>')
  end

end
