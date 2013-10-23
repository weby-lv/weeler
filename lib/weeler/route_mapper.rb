module Weeler::RouteMapper
  # Pass given resource to "resources" mount method and
  # add extra routes for members and collections needed by weeler
  def weeler_resources(*args, &block)
    add_menu_item args[0] if args[0].present? && args[1].present? && args[1][:include_in_weeler_menu] == true
    resources *args do
      yield if block_given?
    end
  end

  def mount_weeler_at mount_location, options={}, &block
    mount_location_namespace = mount_location.gsub("/", "").to_sym
    scope mount_location do
      namespace :weeler, :path => nil do
        mount_translations_controller

        root :to => "home#index"
        get "/about" => "home#about"

        yield if block_given?
      end
    end
  end

  private

  # Add menu item for resource
  def add_menu_item resource
    Weeler.menu_items << resource unless Weeler.menu_items.select{ |item| item == resource }.size > 0
  end

  # Mount translations controller
  def mount_translations_controller
    resources :translations, :except => [:show] do
      collection do
        get :export
        post :import
      end
    end
  end

  def include_routes? route, options
    include_route = true
    if options.is_a? Hash
      if options[:only] && !options[:only].include?(route.to_sym)
        include_route = false
      elsif options[:except].try(:include?, route.to_sym)
        include_route = false
      end
    end

    return include_route
  end
end # Weeler::RouteMapper