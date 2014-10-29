# Weeler I18n backend export helper module.
#
# Export all translations in excel (xlsx)
#
#   def export
#     respond_to do |format|
#       format.xlsx do
#         outstrio = StringIO.new
#         outstrio.write(I18n::Backend::Weeler::Translation.all.as_xlsx_package.to_stream.read)
#         send_data(outstrio.string, filename: "translations" + '.xlsx')
#       end
#     end
#   end

begin
  require 'axlsx'
rescue LoadError => e
  puts "can't use Exporter because: #{e.message}"
end

module I18n
  module Backend
    class Weeler
      module Exporter
        extend ActiveSupport::Concern

        module ClassMethods

          # Prepare xlsx package from current scope
          # Stores all translations in translations worksheet.
          def as_xlsx_package
            package = Axlsx::Package.new
            package.use_shared_strings = true

            sheet = package.workbook.add_worksheet(name: "translations")

            locales = I18n.available_locales
            sheet.add_row(Translation.title_row(locales))

            types = []
            (locales.size + 1).times { types << :string }

            included_keys = []

            self.current_scope.each do |translation|
              unless included_keys.include? translation.key
                sheet.add_row(Translation.translation_row_by_key_and_locales(translation.key, locales), types: types)
                included_keys << translation.key
              end
            end
            return package
          end

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

        Translation.send(:include, self)
      end
    end
  end
end
