module Weeler
  module ActionController
    module ShowTranslationKeys
      extend ActiveSupport::Concern

      included do
        before_action :set_show_translation_keys
      end

      private

      def set_show_translation_keys
        if params[:show_keys].present?
          session[:show_translation_keys] = params[:show_keys]
        end
      end

    end
  end
end
