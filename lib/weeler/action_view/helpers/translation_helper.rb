module Weeler
  module ActionView
    module Helpers
      module TranslationHelper
        extend ActiveSupport::Concern

        def translate(key, options = {})
          (defined?(Settings) && Settings.show_translation_keys == "on") ? key : super(key, options)
        end
        alias :t :translate

      end
    end
  end
end
