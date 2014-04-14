module Weeler
  class NewsletterContact < ActiveRecord::Base
    self.table_name = "weeler_newsletter_contacts"

    def to_s
      "#{self.full_name} <#{self.email}>"
    end

    def self.as_csv
      require 'csv'
      
      CSV.generate do |csv|
        csv << column_names
        all.each do |item|
          csv << item.attributes.values_at(*column_names)
        end
      end
    end

  end
end