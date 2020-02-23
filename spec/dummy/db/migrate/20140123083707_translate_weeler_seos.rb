class TranslateWeelerSeos < ActiveRecord::Migration[4.2]
  def self.up
    Weeler::Seo.create_translation_table!({
      title: :string,
      description: :text,
      keywords: :text
    }, {
      :migrate_data => true
    })
  end

  def self.down
    Weeler::Seo.drop_translation_table! :migrate_data => true
  end
end
