require "weeler/version"
require "rails"
require "weeler/route_mapper"
require "weeler/engine"
require "kaminari"

module Weeler

  mattr_accessor :create_missing_translations
  @@create_missing_translations = true

  mattr_accessor :use_weeler_i18n
  @@use_weeler_i18n = true

  mattr_accessor :menu_items
  @@menu_items = []

  mattr_accessor :required_user_method
  @@required_user_method = nil

  def self.setup
    if Weeler.use_weeler_i18n
      require "i18n/weeler"
    end

    yield self
  end
end

