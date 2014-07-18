class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :sequence, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
