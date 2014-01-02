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
    mount_redactor_rails
    
    Weeler.mount_location_namespace = mount_location.gsub("/", "").to_sym
    scope mount_location do
      namespace :weeler, :path => nil do
        mount_translations_controller


        weeler_resources :seos, :only => [:update]

        root :to => "home#index"
        get "/home/about"

        get "/content", to: "content#index"
        get "/configurations", to: "configurations#index"

        yield if block_given?
      end
    end
  end

  private

  # Add menu item for resource
  def add_menu_item resource
    # Weeler.menu_items << {name: resource.to_s.capitalize, controller: resource} unless Weeler.menu_items.select{ |item| item == resource.to_s.capitalize }.size > 0
    Weeler.menu_items << {name: resource.to_s.capitalize, weeler_path: resource} unless Weeler.menu_items.select{ |item| item[:name] == resource.to_s.capitalize }.size > 0
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

  # Mount redactor rails for image and file upload
  def mount_redactor_rails
    mount RedactorRails::Engine => '/redactor_rails'
  end
end # Weeler::RouteMapper