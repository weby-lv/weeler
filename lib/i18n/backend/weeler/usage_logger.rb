require 'active_record'

module I18n
  module Backend
    class Weeler

      module UsageLogger

        def log_key_usage(locale, key)
          existing = i18n_cache.read([:usage_stats, [locale, key]])
          value = existing.present? ? (existing.to_i + 1) : 1
          i18n_cache.write [:usage_stats, [locale, key]], value
        end
        
        Weeler.send(:include, UsageLogger)
      end
    end
  end
end
