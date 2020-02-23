class CreateWeelerTranslations < ActiveRecord::Migration[4.2]
  def change
    create_table :weeler_translations do |t|
      t.string :locale
      t.string :key
      t.text   :value
      t.text   :interpolations
      t.boolean :is_proc, :default => false

      t.timestamps
    end

    add_index :weeler_translations, :locale
    add_index :weeler_translations, :key
  end
end
