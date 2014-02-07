require "spec_helper"

describe I18n::Backend::Weeler::Importer do

  # This is file with 10 translations and 3 locales.
  let(:file_path) { Rack::Test::UploadedFile.new(File.dirname(__FILE__) + '/../../../../fixtures/test.xlsx') }

  describe :import do

    context "empty db" do
      before(:each) do
        I18n::Backend::Weeler::Translation.delete_all
        I18n::Backend::Weeler::Translation.import file_path
      end

      it "translation stores all translation in each locale" do
        expect(I18n::Backend::Weeler::Translation.count).to eq(30)
      end

      it "returns value if value is in file" do
        expect(I18n.t(:"welcome.title", :locale => :lv)).to eq("SveikI!")
      end

      it "returns nil if value is not file" do
        expect(I18n.t(:"product.list.open", :locale => :en)).to eq("")
      end

    end


    context "full db" do
      before(:each) do
        I18n::Backend::Weeler::Translation.delete_all
        I18n.backend.store_translations(:en, welcome: {title: 'fooo'})
      end

      it "file import overrides value" do
        expect(I18n.t(:"welcome.title", :locale => :en)).to eq("fooo")
        I18n::Backend::Weeler::Translation.import file_path
        expect(I18n.t(:"welcome.title", :locale => :en)).to eq("EN welcome")
      end

    end

  end

end
