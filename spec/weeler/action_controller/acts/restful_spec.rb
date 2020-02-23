require 'spec_helper'

class Weeler::FoosController < Weeler::ContentController; end

describe Weeler::ActionController::Acts::Restful, type: :controller do

  before(:each) do
    FactoryBot.create_list(:dummy_post, 2)
  end

  before do
    routes.draw do
      mount_weeler_at "/weeler-admin" do
        weeler_resources :foos
      end
    end
  end

  describe "acts_as_restful" do

    context "permited title with array" do
      controller Weeler::FoosController do
        acts_as_restful Post, permit_params: [:title]
      end

      describe "model" do
        it "returns current controller model" do
          expect(controller.model).to eq(Post)
        end
      end

      describe "actions" do
        describe "GET #index" do
          specify "index returns success" do
            routes.draw { get "index" => "weeler/foos#index" }

            get "index"
            expect(response).to have_http_status(200)
          end

          specify "assigns posts" do
            routes.draw { get "index" => "weeler/foos#index" }

            get "index"
            expect(assigns(:items).size).to eq(2)
          end
        end

        describe "POST #create" do
          it "redirects to edit path" do
            # routes.draw do
            #   mount_weeler_at "/weeler-admin" do
            #     weeler_resources :foos
            #   end
            # end

            post "create", params: { post: attributes_for(:dummy_post) }
            post = Post.last
            expect(response).to redirect_to("http://test.host/weeler-admin/foos/#{post.id}/edit")
          end

          it "sets only permited params" do
            post "create", params: { post: attributes_for(:dummy_post, body: "Heila") }
            post = Post.last
            expect(post.title).to eq("Foo bar")
            expect(post.body).to eq(nil)
          end
        end

        describe "GET #edit" do
          it "returns success status" do
            get "edit", params: { id: Post.last.id }
            expect(response).to have_http_status(200)
          end
        end

        describe "GET #new" do
          it "returns success status" do
            get "new"

            expect(response).to have_http_status(200)
          end
        end

        describe "PUT #update" do
          it "sets only permited params" do
            post = Post.last
            put "update", params: { id: post.id, post: {title: "Shivauva", body: "Another world!"} }
            post.reload
            expect(post.title).to eq("Shivauva")
            expect(post.body).to eq("Foo baar bazaar")
          end
        end

        describe "DELETE #destroy" do
          it "destroys item" do
            post = Post.last
            delete "destroy", params: { id: post.id }
            expect { post.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        specify "POST #order" do
          routes.draw { post "order" => "weeler/foos#order" }

          post "order", params: { orders: "order[]=2&order[]=1" }
          post1 = Post.order(sequence: :asc).first
          post2 = Post.order(sequence: :asc).last
          expect(post1.sequence).to eq(0)
          expect(post2.sequence).to eq(1)
          expect(response.body).to eq("all ok")
        end
      end
    end

    context "no permited params" do
      controller Weeler::FoosController do
        acts_as_restful Post
      end

      describe "actions" do
        describe "POST #create" do
          it "sets only permited params" do
            post "create", params: { post: attributes_for(:dummy_post, title: "Foo lala", body: "Heila") }
            post = Post.last
            expect(post.title).to eq(nil)
            expect(post.body).to eq(nil)
          end

          it "warns developer" do
            warning_message = "[UNPERMITED PARAMS] To permit {\"body\"=>\"Heila\", \"title\"=>\"Foo lala\"} params, add 'permit_params: permit_params:' option to 'acts_as_restful'\n"
            expect { post("create", params: { post: attributes_for(:dummy_post, title: "Foo lala", body: "Heila") }) }.to output(warning_message).to_stderr
          end
        end
      end
    end

    context "permited all with block" do
      controller Weeler::FoosController do
        acts_as_restful Post, permit_params: lambda { |params| params.require(:post).permit! }
      end

      describe "actions" do
        describe "POST #create" do
          it "sets only permited params" do
            post "create", params: { post: attributes_for(:dummy_post, title: "Foo lala", body: "Heila") }
            post = Post.last
            expect(post.title).to eq("Foo lala")
            expect(post.body).to eq("Heila")
          end
        end
      end

    end

    context "permited all with block" do
      controller Weeler::FoosController do
        acts_as_restful Post, order_by: {id: :desc}, permit_params: [:title]
      end

      describe "GET #index" do
        it "users order by for ordering" do
          get "index"
          expect(assigns(:items).first.id).to eq(2)
          expect(assigns(:items).last.id).to eq(1)
        end
      end
    end
  end
end
