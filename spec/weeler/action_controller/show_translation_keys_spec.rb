require 'spec_helper'

describe Weeler::ActionController::ShowTranslationKeys, :type => :controller do

  before(:all) do
    Dummy::Application.reload_routes!
  end

  describe "set_show_translation_keys", :type => :controller do

    context "permited title with array" do
      controller(Weeler::ContentController) do
        def index; end
      end

      describe "GET #index" do
        it "sets show_translation_keys" do
          get "index", show_keys: true
          expect(session[:show_translation_keys]).to eq(true)
        end
      end

    end
  end

end
