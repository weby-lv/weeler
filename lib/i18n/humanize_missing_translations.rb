module I18n
  # Show only last part from key in humanize mode
  module HumanizeMissingTranslations
    def call(exception, locale, key, options)
      if exception.is_a?(I18n::MissingTranslation)
        key.to_s.split('.').last.humanize
      else
        super
      end
    end
  end
end
