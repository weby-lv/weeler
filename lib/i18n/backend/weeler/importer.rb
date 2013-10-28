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

          def import path

            xls = Roo::Excelx.new(path, file_warning: :ignore)

            xls.each_with_pagename do |name, sheet|
              
              # Lookup locales
              locales = []
              sheet.row(1).each_with_index do |cell, i|
                if i > 0
                  locales.push(cell.downcase)
                end
              end

              # Lookup values
              (2..sheet.last_row).each do |row_no|
                locale = nil
                key = nil
                value = nil
                sheet.row(row_no).each_with_index do |cell, i|
                  if i == 0
                    key = cell
                  else
                    locale = locales[ i - 1 ]
                    value = cell.nil? ? '' : cell

                    if locale.present? && key.present?
                      translation = Translation.find_or_initialize_by locale: locale, key: key
                      if translation.value != value
                        translation.value = value
                        translation.save
                      end
                    end

                  end
                end # cells

              end # rows

            end # sheets

          end

        end
      end

      Translation.send(:include, Importer)
    end
  end
end