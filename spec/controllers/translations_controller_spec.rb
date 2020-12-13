require 'spec_helper'

describe Weeler::TranslationsController, type: :controller do

  before do
    routes.draw do
      mount_weeler_at "/weeler"
    end
  end

  describe "GET #index" do
    before do
      FactoryBot.create(:translation, key: 'foo.bar')
      FactoryBot.create(:translation, key: 'bar.foo')
    end

    it "list translations" do
      get :index
      expect(assigns(:translations).size).to eq(2)
    end
  end

  describe "#create" do
    it "creates translation in DB" do
      expect(I18n.t("title", locale: :en)).to eq("Title")
      I18n::Backend::Weeler::Translation.delete_all

      post :create, params: { i18n_backend_weeler_translation: FactoryBot.attributes_for(:translation) }

      expect(I18n.t("title", locale: :en)).to eq("This is weeler")
    end

    it "doesnt create a duplicate key" do
      I18n::Backend::Weeler::Translation.delete_all

      post :create, params: { i18n_backend_weeler_translation: {locale: "en", key: "no.dup.title", value: "This is weeler"} }
      expect(I18n.t("no.dup.title", locale: :en)).to eq("This is weeler")

      post :create, params: { i18n_backend_weeler_translation: {locale: "en", key: "no.dup.title", value: "This is weeler"} }
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    it "update translation in DB" do
      I18n::Backend::Weeler::Translation.delete_all
      translation = FactoryBot.create(:translation, key: 'foo.updated', value: nil)

      put "update", params: { id: translation.id, i18n_backend_weeler_translation: {value: "Updated weeler!"} }
      expect(I18n.t("foo.updated", locale: :en)).to eq("Updated weeler!")
    end

    it "dont updates if key is empty" do
      I18n::Backend::Weeler::Translation.delete_all
      translation = FactoryBot.create(:translation, key: 'foo.updated', value: nil)

      put "update", params: { id: translation.id, i18n_backend_weeler_translation: {value: "Updated weeler!", key: nil} }
      expect(response).to render_template(:edit)
    end
  end

  describe "GET #new" do
    it "retern new translation form" do
      get "new"
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "retern edit translation form" do
      translation = FactoryBot.create(:translation, key: 'foo.updated', value: nil)
      get "edit", params: { id: translation.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE #destroy" do
    it "destroys translation" do
      translation = FactoryBot.create(:translation, key: 'foo.removing', value: "Bla bla")
      delete "destroy", params: { id: translation.id }

      expect(I18n.t("foo.removing", locale: :en)).to eq("Removing") # Returns empty key
    end
  end

  describe "POST #import" do
    context "submiting a file" do
      it "adds translation from files" do
        I18n::Backend::Weeler::Translation.delete_all
        Setting.i18n_updated_at = Time.current

        expect(I18n.t("welcome.title", locale: :en)).to eq("Title") # Missing translation
        post "import", params: { file: fixture_file_upload(File.dirname(__FILE__) + '/../fixtures/test.xlsx', 'application/xlsx') }
        expect(I18n.t("welcome.title", locale: :en)).to eq("EN welcome")
      end
    end

    context "no file" do
      it "redirects back" do
        post "import"
        expect(response).to redirect_to :weeler_translations
      end

    end


  end

  describe "GET #export" do
    it "retursns translation file" do
      get "export", format: :xlsx
      expect(response.headers["Content-Type"]).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"translations.xlsx\"; filename*=UTF-8''translations.xlsx")
    end
  end

end
