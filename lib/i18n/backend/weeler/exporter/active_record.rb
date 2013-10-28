module I18n
  module Backend
    class Weeler
      module Exporter

        module ActiveRecord
          extend ActiveSupport::Concern

          module ClassMethods

            def title_row locales
              row = [ 'Key' ]
              locales.each do |locale|
                row.push(locale.capitalize)
              end
              row
            end

            def translation_row_by_key_and_locales key, locales
              row = [ key ]
              locales.each do |locale|
                result = Translation.locale(locale).lookup(key).load
                if result.first.present?
                  row.push(result.first.value)
                else
                  row.push("")
                end
              end
              row
            end
          end
        end

      end
    end
  end
end