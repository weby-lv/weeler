class CreateWeelerLocks < ActiveRecord::Migration[4.2]
  def self.up
    create_table :weeler_locks do |t|
      t.string :name, :limit => 40
      t.timestamps
    end
    add_index :weeler_locks, :name, :unique => true
  end

  def self.down
    remove_index :weeler_locks, :column => :name
    drop_table :weeler_locks
  end
end
