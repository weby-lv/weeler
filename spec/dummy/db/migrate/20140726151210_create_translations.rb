class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.references :post, index: true
      t.string :locale
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
