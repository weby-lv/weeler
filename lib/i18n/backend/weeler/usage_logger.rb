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

        def dump_key_usage
          already_dumped = i18n_cache.read([:dump_usage_stats, Process.pid]).present?
          unless already_dumped
            Weeler::Lock.acquire('usage_stats_dump') do
              i18n_cache.instance_variable_get(:@data).keys.each do |key|
                if key.start_with?('usage_stats')
                  translation_stat = TranslationStat.find_or_create_by(key: key.gsub('usage_stats/en/', ''))
                  translation_stat.usage_count += i18n_cache.read(key).to_i
                  translation_stat.save!
                end
              end
              i18n_cache.write [:dump_usage_stats, Process.pid], Process.pid
            end
          end
        end

        Weeler.send(:include, UsageLogger)
      end
    end
  end
end
