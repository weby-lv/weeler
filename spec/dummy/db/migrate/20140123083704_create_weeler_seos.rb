class CreateWeelerSeos < ActiveRecord::Migration[4.2]
  def change
    create_table :weeler_seos do |t|
      t.string :title
      t.text :description
      t.text :keywords
      t.string :section
      t.references :seoable, index: true, polymorphic: true

      t.timestamps
    end
    add_index :weeler_seos, :section
  end
end
