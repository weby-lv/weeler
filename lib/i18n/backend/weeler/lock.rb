require 'active_record'

module I18n
  module Backend
    # Weeler model used to store locks
    #
    # This model expects a table like the following to be already set up in
    # your the database:
    #
    # def self.up
    #   create_table :weeler_locks do |t|
    #     t.string :name, :limit => 40
    #     t.timestamps
    #   end
    #   add_index :weeler_locks, :name, :unique => true
    # end
    #
    # def self.down
    #   remove_index :weeler_locks, :column => :name
    #   drop_table :weeler_locks
    # end
    #
    class Weeler
      class Lock < ActiveRecord::Base

        self.table_name = 'weeler_locks'

        def self.acquire(name)
          already_acquired = definitely_acquired?(name)

          if already_acquired
            yield
          else
            begin
              create(:name => name) unless find_by(name: name)
            rescue ActiveRecord::StatementInvalid
              # concurrent create is okay
            end

            begin
              result = nil
              transaction do
                self.lock(true).find_by(name: name) # this is the call that will block
                acquired_lock(name)
                result = yield
              end

              result
            ensure
              maybe_released_lock(name)
            end
          end
        end

        # if true, the lock is acquired
        # if false, the lock might still be acquired, because we were in another db transaction
        def self.definitely_acquired?(name)
          !!Thread.current[:definitely_acquired_locks] and Thread.current[:definitely_acquired_locks].has_key?(name)
        end

        def self.acquired_lock(name)
          logger.debug("Acquired lock '#{name}'")
          Thread.current[:definitely_acquired_locks] ||= {}
          Thread.current[:definitely_acquired_locks][name] = true
        end

        def self.maybe_released_lock(name)
          logger.debug("Released lock '#{name}' (if we are not in a bigger transaction)")
          Thread.current[:definitely_acquired_locks] ||= {}
          Thread.current[:definitely_acquired_locks].delete(name)
        end

        private_class_method :acquired_lock, :maybe_released_lock

      end
    end
  end
end
