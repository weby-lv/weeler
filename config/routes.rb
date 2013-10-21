=begin
Weeler::Engine.routes.draw do

  # Pass given resource to "resources" mount method and
  # add extra routes for members and collections needed by weeler
  def weeler_resources(*args, &block)
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> weeler_resources: #{args.inspect}"
    resources *args do
      yield if block_given?
      get :confirm_destroy, :on => :member if include_confirm_destroy?(args.last)
    end
  end

  # Mount translations controller
  def mount_translations_controller
    weeler_resources :translations, :controller => "translations", :path => "translations", :except => [:show] do
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


  namespace :weeler, :path => nil do
    mount_translations_controller
    get "/about", :to => "home#about"
    root :to => "home#index"
    # get '/*path' => 'home#page_not_found'
  end

  yield if block_given?

end
=end