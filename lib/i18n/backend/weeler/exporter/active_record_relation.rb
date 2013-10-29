module I18n
  module Backend
    class Weeler
      module Exporter

        module ActiveRecordRelation
          
          def as_xlsx_package
            # construct xlsx file
            p = Axlsx::Package.new
            # Numbers requires this
            p.use_shared_strings = true
            
            sheet = p.workbook.add_worksheet(name: "translations")
            
            # All used locales and translations by params
            locales = Translation.available_locales
            locales = locales.select{ |l| l.present? }

            sheet.add_row(Translation.title_row(locales))

            included_keys = []

            self.each do |translation|
              unless included_keys.include? translation.key
                sheet.add_row(Translation.translation_row_by_key_and_locales(translation.key, locales))
                included_keys << translation.key
              end
            end
            return p
          end

        end

      end
    end
  end
end