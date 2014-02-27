# This module is intended to be mixed into the Weeler backend to allow
# storing Ruby Procs as translation values in the database.
#
#   I18n.backend = I18n::Backend::Weeler.new
#   I18n::Backend::Weeler::Translation.send(:include, I18n::Backend::Weeler::StoreProcs)
#
# The StoreProcs module requires the ParseTree and ruby2ruby gems and therefor
# was extracted from the original backend.
#
# ParseTree is not compatible with Ruby 1.9.

begin
  require 'ruby2ruby'
rescue LoadError => e
  puts "can't use StoreProcs because: #{e.message}"
end

module I18n
  module Backend
    class Weeler
      module StoreProcs
        def value=(v)
          case v
          when Proc
            write_attribute(:value, v.to_ruby)
            write_attribute(:is_proc, true)
          else
            write_attribute(:value, v)
          end
        end

        Translation.send(:include, self) if method(:to_s).respond_to?(:to_ruby)
      end
    end
  end
end

