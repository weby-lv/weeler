module Weeler

  class Engine < ::Rails::Engine
    config.railties_order = [:main_app, Weeler::Engine, :all]
    config.weeler = Weeler

    config.i18n.available_locales = [:en] unless config.i18n.available_locales.present?

    config.assets.precompile += ["weeler/init.js", "weeler/init.css"]
  end

  ActiveSupport.on_load :action_controller do
    ActionDispatch::Routing::Mapper.send(:include, Weeler::RouteMapper)

  end

end
