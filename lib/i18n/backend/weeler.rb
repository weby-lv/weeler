require 'i18n/backend/base'
require 'i18n/backend/weeler/translation'
require 'i18n/backend/weeler/exporter'
require 'i18n/backend/weeler/importer'

module I18n
  module Backend
    class Weeler
      PLURAL_KEYS = ["zero", "one", "other"]

      autoload :StoreProcs,  'i18n/backend/weeler/store_procs'
      autoload :Translation, 'i18n/backend/weeler/translation'
      autoload :Exporter,    'i18n/backend/weeler/exporter'
      autoload :Importer,    'i18n/backend/weeler/importer'

      module Implementation
        include Base, Flatten

        def available_locales
          begin
            Translation.available_locales
          rescue ::ActiveRecord::StatementInvalid
            []
          end
        end

        def store_translations(locale, data, options = {})
          escape = options.fetch(:escape, true)
          flatten_translations(locale, data, escape, false).each do |key, value|
            Translation.locale(locale).lookup(expand_keys(key)).delete_all
            Translation.create(:locale => locale.to_s, :key => key.to_s, :value => value)
          end
        end

      protected

        def lookup(locale, key, scope = [], options = {})
          key = normalize_flat_keys(locale, key, scope, options[:separator])
          result = Translation.locale(locale).lookup(key).load

          if result.empty?
            if ::Weeler.create_missing_translations
              interpolations = options.keys - I18n::RESERVED_KEYS
              keys = options[:count] ? PLURAL_KEYS.map { |k| [key, k].join(FLATTEN_SEPARATOR) } : [key]
              keys.each { |key| store_translation(locale, key, interpolations) }
            end
            nil
          elsif result.first.key == key
            result.first.value
          else
            chop_range = (key.size + FLATTEN_SEPARATOR.size)..-1
            result = result.inject({}) do |hash, r|
              hash[r.key.slice(chop_range)] = r.value
              hash
            end
            result.deep_symbolize_keys
          end
        end

        # For a key :'foo.bar.baz' return ['foo', 'foo.bar', 'foo.bar.baz']
        def expand_keys(key)
          key.to_s.split(FLATTEN_SEPARATOR).inject([]) do |keys, key|
            keys << [keys.last, key].compact.join(FLATTEN_SEPARATOR)
          end
        end

        # Store single empty translation
        def store_translation(locale, key, interpolations)
          translation = Weeler::Translation.new :locale => locale.to_s, :key => key
          translation.interpolations = interpolations
          translation.save
        end

      end

      include Implementation
    end
  end
end

