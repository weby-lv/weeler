require 'active_record'

module I18n
  module Backend
    # Weeler model used to store translation key usage statistics
    #
    # This model expects a table like the following to be already set up in
    # your the database:
    #
    #   create_table :weeler_translation_stats do |t|
    #     t.string :key
    #     t.integer :usage_count, default: 0
    #   end
    #
    class Weeler
      class TranslationStat < ::ActiveRecord::Base

        self.table_name = 'weeler_translation_stats'

        validates :key, uniqueness: true
        validates :key, :usage_count, presence: true
      end
    end
  end
end
