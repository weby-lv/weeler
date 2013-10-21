module Weeler::RouteMapper
  # Pass given resource to "resources" mount method and
  # add extra routes for members and collections needed by weeler
  def weeler_resources(*args, &block)
    resources *args do
      yield if block_given?
      puts ">>>>>>>>>>>> RESOURCES: #{args[0]}"
      get   :confirm_destroy, :on => :member if include_confirm_destroy?(args.last)
    end
  end

  def mount_weeler_at mount_location, options={}, &block

    mount_location_namespace = mount_location.gsub("/", "").to_sym
    scope mount_location do
      if mount_location_namespace.empty?
        yield if block_given?
      else
        namespace mount_location_namespace, :path => nil do
          yield if block_given?
        end
      end

      namespace :weeler, :path => nil do
        mount_translations_controller

        root :to => "home#index"
        get "/about" => "home#about"
      end
    end
  end

  private

  # Mount translations controller
  def mount_translations_controller
    weeler_resources :translations, :except => [:show] do
      member do
        get :export
        post :import
      end
    end
  end

  # Check whether add confirm destroy route
  def include_confirm_destroy? options
    return include_routes? :destroy, options
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