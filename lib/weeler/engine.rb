module Weeler
  class Engine < ::Rails::Engine
    config.railties_order = [:main_app, Weeler::Engine, :all]
    config.weeler = Weeler
  end

  ActiveSupport.on_load :action_controller do
    ActionDispatch::Routing::Mapper.send(:include, Weeler::RouteMapper)
  end

end