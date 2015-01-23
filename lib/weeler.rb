require "weeler/version"
require "weeler/deprecator"

require 'logger'
require "rails"

require "weeler/engine"

# 3rd party
require "haml"
require "kaminari"
require "globalize"
require "jquery-ui-rails"
require "jquery-turbolinks"
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
  
  mattr_accessor :empty_translation_acts_like_missing
  @@empty_translation_acts_like_missing = true

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
    if Weeler.use_weeler_i18n == true && ActiveRecord::Base.connection.table_exists?('weeler_translations')
      require "i18n/weeler"
      Weeler.static_sections.each do |key, section|
        Weeler.static_menu_items << {name: key.to_s.capitalize, weeler_path: "static_sections/#{key}"}
      end
    end
    build_main_menu
  end

  def self.build_main_menu
    home_menu_item = {name: "Home", weeler_path: ""}
    content_menu_item = {name: "Content", weeler_path: "content"}
    administration_menu_item = {name: "Administration", weeler_path: "administration"}
    configuration_menu_item = {name: "Configuration", weeler_path: "configuration"}

    Weeler.main_menu_items.delete(home_menu_item)
    Weeler.main_menu_items.delete(content_menu_item)
    Weeler.main_menu_items.delete(administration_menu_item)
    Weeler.main_menu_items.delete(configuration_menu_item)


    Weeler.main_menu_items.insert(0, {name: "Home", weeler_path: ""}) unless Weeler.main_menu_items.include?(home_menu_item)

    if (Weeler.content_menu_items.size > 0 || Weeler.static_menu_items.size > 0) && !Weeler.main_menu_items.include?(content_menu_item)
      Weeler.main_menu_items.insert(1, {name: "Content", weeler_path: "content"})
    end

    Weeler.main_menu_items.insert(2, administration_menu_item) if Weeler.administration_menu_items.size > 0 && !Weeler.main_menu_items.include?(administration_menu_item)
    Weeler.main_menu_items.push(configuration_menu_item) unless Weeler.main_menu_items.include?(configuration_menu_item)
    Weeler.main_menu_items = Weeler.main_menu_items.compact
  end

  def self.translations
    I18n::Backend::Weeler::Translation if Weeler.use_weeler_i18n == true
  end
end
