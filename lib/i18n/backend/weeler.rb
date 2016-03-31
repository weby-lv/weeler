require 'i18n/backend/base'
require 'i18n/backend/weeler/translation'
require 'i18n/backend/weeler/dedupe'
require 'i18n/backend/weeler/html_checker'
require 'i18n/backend/weeler/exporter'
require 'i18n/backend/weeler/importer'
require 'i18n/backend/weeler/usage_logger'
require 'i18n/backend/weeler/translation_stat'
require 'i18n/backend/weeler/lock'

module I18n
  module Backend
    # I18n backend by weeler for storing translations in database and caching.
    #
    # It implements storing all translation in <tt>Translation</tt> active record moduel table.
    # When application is running, it stores translation in cache for better performance.
    #
    # Also this backend provides extra moduls:
    # * HTML checher, for storing html translations.
    # * exporter - for export all translations in xlsx
    # * importer - for importing all translations
    # * Dedupe - you should use if you find duplicated keys
    #
    class Weeler
      attr_accessor :i18n_cache

      PLURAL_KEYS = ["zero", "one", "other"]

      autoload :HtmlChecker,     'i18n/backend/weeler/html_checker'
      autoload :Translation,     'i18n/backend/weeler/dedupe'
      autoload :Translation,     'i18n/backend/weeler/translation'
      autoload :Exporter,        'i18n/backend/weeler/exporter'
      autoload :Importer,        'i18n/backend/weeler/importer'
      autoload :UsageLogger,     'i18n/backend/weeler/usage_logger'
      autoload :TranslationStat, 'i18n/backend/weeler/translation_stat'
      autoload :Lock,            'i18n/backend/weeler/lock'

      module Implementation
        include Base, Flatten

        def store_translations(locale, data, options = {})
          escape = options.fetch(:escape, true)
          flatten_translations(locale, data, escape, false).each do |key, value|
            Translation.locale(locale).lookup(expand_keys(key)).delete_all
            Translation.create(locale: locale.to_s, key: key.to_s, value: value)
          end
        end

        def reload_cache
          i18n_cache.clear

          Translation.all.each do |translation|
            # Load in cache unless value is nil or it is blank and empty
            # translation acts like missing
            if !(translation.value.nil? || (::Weeler.empty_translation_acts_like_missing && translation.value.blank?))
              i18n_cache.write [translation.locale, translation.key], translation
            end
          end

          i18n_cache.write('UPDATED_AT', Settings.i18n_updated_at) if ActiveRecord::Base.connection.table_exists?('settings')
        end

        protected

        def lookup(locale, key, scope = [], options = {})
          return fallback_backend_translation locale, key if key.to_s.start_with?('i18n')
          key = normalize_flat_keys(locale, key, scope, options[:separator])
          return lookup_in_cache(locale, key, scope, options)
        end

        private

        def lookup_in_cache locale, key, scope = [], options = {}
          # reload cache if cache timestamp differs from last translations update
          reload_cache if ((!ActiveRecord::Base.connection.table_exists?('settings')) || i18n_cache.read('UPDATED_AT') != Settings.i18n_updated_at)

          # log locale/key usage for statistics
          if Settings.log_key_usage == 'true'
            i18n_cache.delete([:dump_usage_stats, Process.pid])
            log_key_usage(locale, key)
          end

          if Settings.log_key_usage == 'dump'
            dump_key_usage
          end

          return nil if i18n_cache.read([:missing, [locale, key]])

          keys = expand_keys key

          keys.reverse.each do |check_key|

            result = i18n_cache.read([locale, check_key])

            return result.value unless result.blank?
          end

          # mark translation as missing
          i18n_cache.write([:missing, [locale, key]], true)

          if ::Weeler.create_missing_translations
            return store_empty_translation locale, key, options
          else
            return nil
          end
        end

        def lookup_in_database locale, key, scope = [], options = {}
          result = Translation.locale(locale).lookup(key).load

          if result.nil? || (::Weeler.empty_translation_acts_like_missing && result.blank?)
            if ::Weeler.create_missing_translations
              return store_empty_translation locale, key, options
            else
              return nil
            end
          elsif result.first.key == key
            translation = result.first
            if translation.value.blank?
              fallback_value = fallback_backend_translation locale, key
              translation.update_attributes value: fallback_value if fallback_value.present?
            end
            return translation.value
          else
            chop_range = (key.size + FLATTEN_SEPARATOR.size)..-1
            result = result.inject({}) do |hash, r|
              hash[r.key.slice(chop_range)] = r.value
              hash
            end
            return result.deep_symbolize_keys
          end
        end

        # For a key :'foo.bar.baz' return ['foo', 'foo.bar', 'foo.bar.baz']
        def expand_keys(not_expanded_key)
          not_expanded_key.to_s.split(FLATTEN_SEPARATOR).inject([]) do |keys, key|
            keys << [keys.last, key].compact.join(FLATTEN_SEPARATOR)
          end
        end

        # Store single empty translation
        def store_empty_translation locale, singular_key, options
          return_value = nil
          interpolations = options.keys - I18n::RESERVED_KEYS

          keys = options[:count] ? PLURAL_KEYS.map { |k| [singular_key, k].join(FLATTEN_SEPARATOR) } : [singular_key]


          keys.each do |key|
            translation = Weeler::Translation.find_or_initialize_by locale: locale.to_s, key: key
            translation.interpolations = interpolations
            fallback_value = fallback_backend_translation locale, key
            if fallback_value.present?
              translation.value = fallback_value
              translation.save
              reload_cache
            else
              translation.save
            end
            return_value = translation.value
          end
          return_value
        end


        def fallback_backend_translation locale, key
          if I18n.backend.backends.size > 1
            alternative_backend = I18n.backend.backends[1]
            alternative_backend.send(:lookup, locale, key)
          else
            nil
          end
        end

      end

      include Implementation
    end
  end
end
