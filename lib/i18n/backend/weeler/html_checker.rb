# This module is intended to be mixed into the Weeler backend to allow
# checks if translation is html
#
#   I18n.backend = I18n::Backend::Weeler.new
#   I18n::Backend::Weeler::Translation.send(:include, I18n::Backend::Weeler::HtmlChecker)
#
# The HtmlChecker module requires html-scanner
# was extracted from the original backend.

begin
  # require 'sanitize'
  require 'action_controller/base'
rescue LoadError => e
  puts "can't use Html because: #{e.message}"
end

module I18n
  module Backend
    class Weeler
      
      module HtmlChecker
        
        # include ActionView::Helpers::SanitizeHelper

        def html?
          if html_safe_translation_key?(self.key) ||
              (self.value.present? && ActionController::Base.helpers.sanitize(self.value.to_s, {tags: []}).length != self.value.to_s.length)
            return true
          else
            return false
          end
        end

      private

        def html_safe_translation_key?(key)
          key.to_s =~ /(\b|_|\.)html$/
        end

        Translation.send(:include, HtmlChecker)
      end
    end
  end
end

