# This module is intended to be mixed into the Weeler backend to allow
# remove all dublicates from translation table
#
#   I18n.backend = I18n::Backend::Weeler.new
#   I18n::Backend::Weeler::Translation.send(:include, I18n::Backend::Weeler::Dedupe)

module I18n
  module Backend
    class Weeler
      module Dedupe
        extend ActiveSupport::Concern

        module ClassMethods
          def dedupe
            # find all models and group them on keys which should be common
            grouped = all.group_by{|model| [model.locale,model.key] }
            grouped.values.each do |duplicates|
              # the first one we want to keep right?
              first_one = duplicates.shift # or pop for last one
              # if there are any more left, they are duplicates
              # so delete all of them
              duplicates.each{|double| double.destroy} # duplicates can now be destroyed
            end
          end
        end

        Translation.send(:include, Dedupe)
      end
    end
  end
end
