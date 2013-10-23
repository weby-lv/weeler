module Weeler
  class Engine < ::Rails::Engine
    config.weeler = Weeler
    isolate_namespace Weeler
  end

  ActiveSupport.on_load :action_controller do
    ActionDispatch::Routing::Mapper.send(:include, Weeler::RouteMapper)
  end

end