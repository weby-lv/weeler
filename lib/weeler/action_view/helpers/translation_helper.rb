module Weeler
  module ActionView
    module Helpers
      module TranslationHelper
        extend ActiveSupport::Concern

        def translate(key, options = {})
          request.present? && request.params[:show_translation_keys] == "true" ? key : super(key, options)
        end
        alias :t :translate

      end
    end
  end
end
