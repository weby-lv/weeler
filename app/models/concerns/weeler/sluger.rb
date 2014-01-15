module Weeler
  module Sluger
    extend ActiveSupport::Concern
    
    included do
      after_save :

      @@sluger_param = :title
    end

    def set_slug
      I18n.available_locales.each do |locale|
        Globalize.with_locale(locale) do
          if self.slug != generate_slug
            self.slug = generate_slug
            self.save!
          end
        end
      end
    end

    def generate_slug
      transliterated = "-#{I18n.transliterate(self[@@sluger_param]).parameterize}" if self[@@sluger_param].present?
      transliterated = "" if transliterated.blank?
      "#{self.id}#{transliterated}"
    end

    def to_param
      slug
    end

  end
end