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

            tranlsations_by_locales = Translation.where(locale: locales).group_by(&:locale)

            current_scope.each do |translation|
              next if included_keys.include?(translation.key)

              row = Translation.translation_row_by_key_and_locales(tranlsations_by_locales, translation.key, locales)
              sheet.add_row(row, types: types)
              included_keys << translation.key
            end

            package
          end

          def title_row(locales)
            row = [ 'Key' ]
            locales.each do |locale|
              row.push(locale.capitalize)
            end

            row.push('Created at')
            row.push('Updated at')

            row
          end

          def translation_row_by_key_and_locales(tranlsations_by_locales, key, locales)
            row = [key]
            created_ats = []
            updated_ats = []

            locales.each do |locale|
              translation = tranlsations_by_locales[locale.to_s]&.find { |t| t.key == key }

              if translation.present?
                created_ats.push(translation.created_at)
                updated_ats.push(translation.updated_at)

                row.push(translation.value)
              else
                row.push('')
              end
            end

            row.push(created_ats.min)
            row.push(updated_ats.max)

            row
          end
        end

        Translation.send(:include, self)
      end
    end
  end
end
