require "weeler/version"

require 'logger'
require "rails"

require "weeler/engine" # Brrrr! Work! Work Weeler!

# 3rd party
require "haml"
require "kaminari"
require "globalize"
require "jquery-ui-rails"
require "rails-settings-cached"

module Weeler
  #
  # => Static sections in content menu bottom
  # => [{about: [{title: :text_field, content: :text_area}]}]
  #
  mattr_accessor :static_sections
  @@static_sections = {}

  mattr_accessor :create_missing_translations
  @@create_missing_translations = true

  mattr_accessor :use_weeler_i18n
  @@use_weeler_i18n = true

  mattr_accessor :required_user_method
  @@required_user_method = nil

  mattr_accessor :logout_path
  @@logout_path = nil

  # Rafacture this to one menu module
  mattr_accessor :content_menu_items
  @@content_menu_items = []

  # Rafacture this to one menu module
  mattr_accessor :static_menu_items
  @@static_menu_items = []

  # Rafacture this to one menu module
  mattr_accessor :administration_menu_items
  @@administration_menu_items = []

  # Rafacture this to one menu module
  mattr_accessor :configuration_menu_items
  @@configuration_menu_items = []

  # Rafacture this to one menu module
  mattr_accessor :main_menu_items
  @@main_menu_items = []

  mattr_accessor :excluded_i18n_groups
  @@excluded_i18n_groups = [:activerecord, :attributes, :helpers, :views, :i18n, :weeler]

  mattr_accessor :i18n_cache
  @@i18n_cache = ActiveSupport::Cache::MemoryStore.new

  mattr_accessor :mount_location_namespace
  @@mount_location_namespace = "weeler"

  def self.setup
    yield self
    if Weeler.use_weeler_i18n == true
      require "i18n/weeler"
      Weeler.static_sections.each do |key, section|
        Weeler.static_menu_items << {name: key.to_s.capitalize, weeler_path: "static_sections/#{key}"}
      end
    end
    build_main_menu
  end

  def self.build_main_menu
    Weeler.main_menu_items =  [{name: "Home", weeler_path: ""}]
    Weeler.main_menu_items << {name: "Content", weeler_path: "content"} if Weeler.content_menu_items.size > 0 || Weeler.static_menu_items.size > 0
    Weeler.main_menu_items << {name: "Administration", weeler_path: "administration"} if Weeler.administration_menu_items.size > 0
    Weeler.main_menu_items << {name: "Configuration", weeler_path: "configuration"} # Add as last one
  end
end
