module Weeler
  module ActionDispatch
    module Routing
      module Mapper

        # Pass given resource to "resources" mount method and
        # add extra routes for members and collections needed by weeler
        #
        # Options:
        # * <tt>include_in_weeler_menu: true</tt> to include this resource in content section.
        #
        def weeler_resources(*args, &block)
          add_menu_item args[0] if args[0].present? && args[1].present? && args[1][:include_in_weeler_menu] == true
          resources *args do
            yield if block_given?
          end
        end

        # Mounts weeler at <tt>mount_location</tt> location.
        # E.g.
        #   mount_weeler_at "root" do
        #     weeler_resources :posts, include_in_weeler_menu: true
        #   end
        #
        def mount_weeler_at mount_location, options={}, &block
          Weeler.mount_location_namespace = mount_location.gsub("/", "").to_sym
          scope mount_location do
            namespace :weeler, :path => nil do
              mount_configuration_controllers

              weeler_resources :static_sections

              resources :seos, :only => [:update]


              root :to => "home#index"
              get "/home/about"
              get "/content", to: "content#index"
              get "/administration", to: "administration#index"
              get "/configuration", to: "configuration#index"

              add_concerns

              yield if block_given?
            end
          end
        end

      private

        # Mount translations controller
        def mount_configuration_controllers
          resources :translations, :except => [:show] do
            collection do
              get :export
              post :import
            end
          end
          resources :seo_items
          resources :settings, :only => [:index, :update, :create]
        end

        # Ordable route concern for dynamic sorting and removing image
        def add_concerns
          concern :orderable do
            collection do
              post :order
            end
          end

          concern :imageable do
            member do
              get "remove_image"
            end
          end
        end

        # Add route menu
        def add_menu_item resource
          Weeler.content_menu_items << {name: resource.to_s.capitalize, weeler_path: resource} unless Weeler.content_menu_items.select{ |item| item[:name] == resource.to_s.capitalize }.size > 0
          Weeler.build_main_menu
        end

      end # Mapper
    end
  end
end
