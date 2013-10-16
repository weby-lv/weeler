require "weeler/version"
require "rails"
# Require our engine
require "weeler/engine"

module Weeler

  mattr_accessor :create_missing_translations
  @@create_missing_translations = true

  mattr_accessor :available_locales
  @@available_locales = ["en"]

  mattr_accessor :use_weeler_i18n
  @@use_weeler_i18n = true

  def self.setup
    I18n.available_locales = Weeler.available_locales

    if Weeler.use_weeler_i18n
      require "i18n/weeler"
    end

    yield self

  end
end

