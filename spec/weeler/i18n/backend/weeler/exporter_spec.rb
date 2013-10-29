require "spec_helper"

describe I18n::Backend::Weeler::Exporter do

  describe :as_xlsx_package do

    context "all translations" do
      before(:all) do
        I18n::Backend::Weeler::Translation.delete_all
        I18n.backend.store_translations(:en, foo: {one: 'test'})
        I18n.backend.store_translations(:en, foo: {two: nil })
        I18n.backend.store_translations(:lv, foo: {two: "some"})

        @rows = I18n::Backend::Weeler::Translation.all.as_xlsx_package.workbook.worksheets[0].rows
      end

      it "should have 3 rows" do
        expect(@rows.size).to be(3)
      end

      it "first row should be title" do
        expect(@rows.first.cells[0].value).to eq("Key")
        expect(@rows.first.cells[1].value).to eq("En")
        expect(@rows.first.cells[2].value).to eq("Lv")
      end

      it "other row with one translation" do
        expect(@rows[1].cells[0].value).to eq("foo.one")
        expect(@rows[1].cells[1].value).to eq("test")
        expect(@rows[1].cells[2].value).to eq("")
      end

      it "other row with two translation" do
        expect(@rows[2].cells[0].value).to eq("foo.two")
        expect(@rows[2].cells[1].value).to eq(nil)
        expect(@rows[2].cells[2].value).to eq("some")
      end
    end

    context "selected translations" do
      before(:all) do
        I18n::Backend::Weeler::Translation.delete_all
        I18n.backend.store_translations(:en, foo: {one: 'test'})
        I18n.backend.store_translations(:en, foo: {two: nil })
        I18n.backend.store_translations(:lv, foo: {two: "some"})

        translations = I18n::Backend::Weeler::Translation.where(key: "foo.one").load
        translations.size
        @other_rows = translations.as_xlsx_package.workbook.worksheets[0].rows
       
      end

      it "should have 2 rows" do
        expect(@other_rows.size).to be(2)
      end

      it "first row should be title" do
        expect(@other_rows.first.cells[0].value).to eq("Key")
        expect(@other_rows.first.cells[1].value).to eq("En")
        expect(@other_rows.first.cells[2].value).to eq("Lv")
      end

      it "other row with one translation" do
        expect(@other_rows[1].cells[0].value).to eq("foo.one")
        expect(@other_rows[1].cells[1].value).to eq("test")
        expect(@other_rows[1].cells[2].value).to eq("")
      end
    end

  end

end