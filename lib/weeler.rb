require "weeler/version"
require "rails"
require "weeler/route_mapper"
require "weeler/engine"
require "kaminari"
require "globalize"
require "jquery-ui-rails"
require "carrierwave"
require "mini_magick"
require "redactor-rails"

module Weeler

  mattr_accessor :create_missing_translations
  @@create_missing_translations = true

  mattr_accessor :use_weeler_i18n
  @@use_weeler_i18n = true

  mattr_accessor :required_user_method
  @@required_user_method = nil

  mattr_accessor :menu_items
  @@menu_items = []

  mattr_accessor :mount_location_namespace
  @@mount_location_namespace = "weeler"

  def self.setup
    if Weeler.use_weeler_i18n
      require "i18n/weeler"
    end
    yield self
  end
end

