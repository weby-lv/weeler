require "spec_helper"

describe I18n::Backend::Weeler::Dedupe do

  describe "#dedupe" do

    context "empty db" do
      before(:each) do
        3.times { I18n::Backend::Weeler::Translation.create(locale: :en, key: "weeler.dublicate") }
        I18n::Backend::Weeler::Translation.dedupe
      end

      it "translation stores all translation in each locale" do
        expect(I18n::Backend::Weeler::Translation.locale(:en).where(key: "weeler.dublicate").size).to eq(1)
      end

    end

  end

end
