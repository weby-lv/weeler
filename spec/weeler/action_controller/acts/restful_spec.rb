require 'spec_helper'

describe Weeler::ActionController::Acts::Restful, :type => :controller do

  before(:each) do
    FactoryGirl.create_list(:dummy_post, 2)
  end

  before(:all) do
    Dummy::Application.reload_routes!
  end

  describe "acts_as_restful", :type => :controller do

    context "permited title with array" do
      controller(Weeler::ContentController) do
        acts_as_restful Post, permit_params: [:title]
      end

      describe "model" do
        it "returns current controller model" do
          expect(controller.model).to eq(Post)
        end
      end

      describe "actions" do
        describe "GET #index" do
          it "returns success" do
            get "index"
            response.should be_success
          end

          it "assigns posts" do
            get "index"
            expect(assigns(:items).size).to eq(2)
          end
        end

        describe "POST #create" do
          it "redirects to edit path" do
            post "create", post: attributes_for(:dummy_post)
            post = Post.last
            expect(response).to redirect_to("http://test.host/anonymous/#{post.id}/edit")
          end

          it "sets only permited params" do
            post "create", post: attributes_for(:dummy_post, body: "Heila")
            post = Post.last
            expect(post.title).to eq("Foo bar")
            expect(post.body).to eq(nil)
          end
        end

        describe "GET #edit" do
          it "returns success status" do
            get "edit", id: Post.last.id
            response.should be_success
          end
        end

        describe "GET #new" do
          it "returns success status" do
            get "new"
            response.should be_success
          end
        end

        describe "PUT #update" do
          it "sets only permited params" do
            post = Post.last
            put "update", id: post.id, post: {title: "Shivauva", body: "Another world!"}
            post.reload
            expect(post.title).to eq("Shivauva")
            expect(post.body).to eq("Foo baar bazaar")
          end
        end

        describe "DELETE #destroy" do
          it "destroys item" do
            post = Post.last
            delete "destroy", id: post.id
            expect { post.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        specify "POST #order" do
          routes.draw { post "order" => "anonymous#order" }

          post "order", orders: "order[]=2&order[]=1"
          post1 = Post.order(sequence: :asc).first
          post2 = Post.order(sequence: :asc).last
          expect(post1.sequence).to eq(0)
          expect(post2.sequence).to eq(1)
          expect(response.body).to eq("all ok")
        end
      end
    end

    context "no permited params" do
      controller(Weeler::ContentController) do
        acts_as_restful Post
      end

      describe "actions" do
        describe "POST #create" do
          it "sets only permited params" do
            post "create", post: attributes_for(:dummy_post, title: "Foo lala", body: "Heila")
            post = Post.last
            expect(post.title).to eq(nil)
            expect(post.body).to eq(nil)
          end

          it "warns developer" do
            controller.should_receive(:warn).with("[UNPERMITED PARAMS] To permiting {\"title\"=>\"Foo lala\", \"body\"=>\"Heila\"} params, add 'permit_params: [:title, :body]' option to 'acts_as_restful'")
            post "create", post: attributes_for(:dummy_post, title: "Foo lala", body: "Heila")
          end
        end
      end
    end

    context "permited all with block" do
      controller(Weeler::ContentController) do
        acts_as_restful Post, permit_params: -> (params) { params.require(:post).permit! }
      end

      describe "actions" do
        describe "POST #create" do
          it "sets only permited params" do
            post "create", post: attributes_for(:dummy_post, title: "Foo lala", body: "Heila")
            post = Post.last
            expect(post.title).to eq("Foo lala")
            expect(post.body).to eq("Heila")
          end
        end
      end

    end


  end
end
