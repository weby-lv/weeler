module Weeler
  class Seo < ActiveRecord::Base
    self.table_name = "weeler_seos"
    translates :title, :description, :keywords

    belongs_to :seoable, polymorphic: true
    accepts_nested_attributes_for :translations
  end
end
