module Weeler
  module ActionView
    module Helpers
      module GlobalizeFormHelper
        def globalize_fields_for(locale, params = nil, options = {}, &block)
          raise ArgumentError, "Missing block" unless block_given?
          @index = @index ? @index + 1 : 1
          object_name = "#{@object_name}[translations_attributes][#{@index}]"
          object = @object.translations.find_or_initialize_by locale: locale.to_s

          if params && params[@object_name] && params[@object_name]["translations_attributes"].present? && params[@object_name]["translations_attributes"]["#{@index}"].present?
            params[@object_name]["translations_attributes"]["#{@index}"].each do |attribute|
              object[attribute[0]] = attribute[1] if attribute[0].present?
            end
          end

          @template.concat @template.hidden_field_tag("#{object_name}[id]", object ? object.id : "")
          @template.concat @template.hidden_field_tag("#{object_name}[locale]", locale)
          @template.concat @template.fields_for(object_name, object, options, &block)
        end
        deprecate :globalize_fields_for, deprecator: Weeler::Deprecator.new

      end
    end
  end
end
