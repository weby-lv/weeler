module Weeler
  module Seoable
    extend ActiveSupport::Concern
    include ActionView::Helpers::TextHelper

    included do
      # Set relations
      has_one :seo,   as: :seoable,   :dependent => :destroy
      accepts_nested_attributes_for :seo,   :reject_if => :all_blank, :allow_destroy => true

      # Callbacks
      after_save :generate_seo

      @@force_seoable = false
    end

    # Generate seo data in each avaivable locale
    #
    def generate_seo
      self.seo = Seo.create if self.seo.blank?

      I18n.available_locales.each do |locale|
        Globalize.with_locale(locale) do
          
          self.seo.title = seo_attribute :title
          self.seo.description = seo_attribute :content, length: 159

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
      truncate(ActionView::Base.full_sanitizer.sanitize(text).strip, omission: '', length: length)
    end

  end
end