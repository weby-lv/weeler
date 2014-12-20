require "weeler/action_controller/acts/restful"
require "weeler/action_dispatch/routing/mapper"
require "weeler/action_view/helpers/form_helper"
require "weeler/action_view/helpers/translation_helper"

module Weeler

  class Engine < ::Rails::Engine
    config.railties_order = [:main_app, Weeler::Engine, :all]
    config.weeler = Weeler

    config.i18n.available_locales = [:en] unless config.i18n.available_locales.present?

    config.assets.precompile += ["weeler/init.js", "weeler/init.css"]

    # Load extend Rails classes
    ::ActionDispatch::Routing::Mapper.send(:include, Weeler::ActionDispatch::Routing::Mapper)
    ::ActionController::Base.send(:include, Weeler::ActionController::Acts::Restful)

    ::ActionView::Helpers::FormBuilder.send(:include, Weeler::ActionView::Helpers::FormHelper)
    ::ActionView::Base.send(:include, Weeler::ActionView::Helpers::TranslationHelper)
  end

end
