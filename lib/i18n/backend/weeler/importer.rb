begin
  require 'roo'
rescue LoadError => e
  puts "can't use Exporter because: #{e.message}"
end

module I18n
  module Backend
    class Weeler

      module Importer
        extend ActiveSupport::Concern

        module ClassMethods

          def import file
            xls = open_spreadsheet file
            xls.each_with_pagename do |name, sheet|

              # Lookup locales
              locales = locales_from_xlsx_sheet_row(sheet.row(1))

              # Lookup values
              (2..sheet.last_row).each do |row_no|
                store_translations_from_xlsx_row(sheet.row(row_no), locales)
              end # rows

            end # sheets

            I18n.backend.backends[0].reload_cache

          end # import

          private

            def open_spreadsheet(file)
              case File.extname(file.original_filename)
              when ".csv"  then Roo::Csv.new(file.path, file_warning: :ignore)
              when ".xls"  then Roo::Excel.new(file.path, file_warning: :ignore)
              when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
              when ".ods"  then Roo::OpenOffice.new(file.path, file_warning: :ignore)
              else raise "Unknown file type: #{file.original_filename}"
              end
            end

            def locales_from_xlsx_sheet_row row
              locales = []
              row.each_with_index do |cell, i|
                if i > 0
                  locales.push(cell.downcase)
                end
              end
              locales
            end

            def store_translations_from_xlsx_row row, locales
              locale = nil
              key = nil
              value = nil

              row.each_with_index do |cell, i|
                if i == 0
                  key = cell
                else
                  locale = locales[ i - 1 ]
                  store_translation_from_xlsx_cell locale, key, cell
                end
              end
            end

            def store_translation_from_xlsx_cell locale, key, cell
              value = cell.nil? ? '' : cell

              if locale.present? && key.present?
                translation = Translation.find_or_initialize_by locale: locale, key: key
                if translation.value != value
                  translation.value = value
                  translation.save
                end
              end
            end

        end
      end

      Translation.send(:include, Importer)
    end
  end
end
