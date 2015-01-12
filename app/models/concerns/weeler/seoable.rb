module Weeler
  module Seoable
    extend ActiveSupport::Concern
    include ::ActionView::Helpers::TextHelper

    included do
      # Set relations
      has_one :seo, as: :seoable, dependent: :destroy, class_name: "Weeler::Seo"
      accepts_nested_attributes_for :seo, reject_if: :all_blank, allow_destroy: true

      # Callbacks
      after_save :generate_seo

      @@force_seoable = true
    end

    # Generate seo data in each avaivable locale
    #
    def generate_seo
      self.seo = Weeler::Seo.create if self.seo.blank?

      I18n.available_locales.each do |locale|
        Globalize.with_locale(locale) do

          if self.respond_to? :seo_title
            self.seo.title = prepare_seoabled_text(seo_title) if (self.seo.title.blank? || @@force_seoable)
          else
            self.seo.title = seo_attribute :title
          end

          if self.respond_to? :seo_description
            self.seo.description = prepare_seoabled_text(seo_description, length: 159) if (self.seo.description.blank? || @@force_seoable)
          else
            self.seo.description = seo_attribute :content, length: 159
          end

          if self.respond_to? :seo_keywords
            self.seo.keywords = prepare_seoabled_text(seo_keywords, length: 200) if (self.seo.keywords.blank? || @@force_seoable)
          end

          self.seo.save
        end
      end
    end

    # Prepeare attribute
    #
    def seo_attribute attribute, length: 80
      if self.has_attribute?(attribute) && self[attribute].present? && (self.seo.title.blank? || @@force_seoable)
        prepare_seoabled_text self[attribute], length: length
      end
    end

    # Strip, sanitize and truncate text in Rails way
    #
    def prepare_seoabled_text text, length: 80
      truncate(::ActionView::Base.full_sanitizer.sanitize(text).strip, omission: '', length: length)
    end

  end
end
