class CreateWeelerTranslationStats < ActiveRecord::Migration
  def change
    create_table :weeler_translation_stats do |t|
      t.string :key
      t.integer :usage_count, default: 0

      t.timestamps
    end
    add_index :weeler_translation_stats, :key
  end
end
