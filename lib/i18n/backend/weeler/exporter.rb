begin
  require 'axlsx'
  require 'i18n/backend/weeler/exporter/active_record'
  require 'i18n/backend/weeler/exporter/active_record_relation'
rescue LoadError => e
  puts "can't use Exporter because: #{e.message}"
end

module I18n
  module Backend
    class Weeler

      Translation.send(:include, Exporter::ActiveRecord)
      # ActiveRecord::Relation::ActiveRecord_Relation_I18n_Backend_Weeler_Translation.send(:include, Exporter::ActiveRecordRelation)

    end
  end
end
