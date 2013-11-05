require "spec_helper"

describe Weeler::Engine.routes do


  after(:all) do
    # reset dummy app routes
    Dummy::Application.reload_routes!
  end

  describe "#mount Weeler::Engine" do
    before do
      routes.draw do
        mount_weeler_at "/weeler-admin"
      end
    end

    it "/weeler returns home" do
      expect(get: "/weeler-admin").to route_to(
        "action"=>"index",
        "controller"=>"weeler/home"
      )
    end

  end

  describe "#add_menu_item" do
    before do
      routes.draw do
        mount_weeler_at '/admin' do
          weeler_resources :mini_posts, include_in_weeler_menu: true 
        end
      end
    end

    it "adds resource to weeler menu item" do
      expect(Weeler.menu_items.size).to eq(1)
      expect(Weeler.menu_items[0][:name]).to eq("Mini_posts")
    end
  end

  describe "#weeler_resources" do
    before do
      routes.draw do
        mount_weeler_at '/admin' do
          weeler_resources :posts
        end
      end
    end

    it "mounts resources index route" do
      expect(get: "/admin/posts/").to route_to(
        "action"=>"index",
        "controller"=>"weeler/posts",
      )
    end

    it "mounts resource create route" do
      expect(post: "/admin/posts/").to route_to(
        "action"=>"create",
        "controller"=>"weeler/posts",
      )
    end

    it "mounts resource new route" do
      expect(get: "/admin/posts/new").to route_to(
        "action"=>"new",
        "controller"=>"weeler/posts",
      )
    end

    it "mounts resource edit route" do
      expect(get: "/admin/posts/1/edit").to route_to(
        "action"=>"edit",
        "controller"=>"weeler/posts",
        "id"=>"1"
      )
    end

    it "mounts resource show route" do
      expect(get: "/admin/posts/1").to route_to(
        "action"=>"show",
        "controller"=>"weeler/posts",
        "id"=>"1"
      )
    end

    it "mounts resource update route" do
      expect(put: "/admin/posts/1").to route_to(
        "action"=>"update",
        "controller"=>"weeler/posts",
        "id"=>"1"
      )
    end

    it "mounts resource destroy route" do
      expect(delete: "/admin/posts/1").to route_to(
        "action"=>"destroy",
        "controller"=>"weeler/posts",
        "id"=>"1"
      )
    end

    context "when destroy route is skiped within with only: option" do
      before do
        routes.draw do
          mount_weeler_at '/admin' do
            weeler_resources :posts, only: [:index]
          end
        end
      end

      it "does not mount destroy confirm route" do
        expect(:delete => "/weeler/posts/1/confirm_destroy").not_to be_routable
      end
    end

    context "when custom block given" do
      before do
        routes.draw do
          mount_weeler_at '/admin' do
            weeler_resources :posts, only: [:index] do
              member do
                get :download
              end
            end
          end
        end
      end

      it "calls it within resources method" do
        expect(get: "/admin/posts/1/download").to route_to(
          "action"=>"download",
          "controller"=>"weeler/posts",
          "id"=>"1"
        )
      end
    end
  end
end