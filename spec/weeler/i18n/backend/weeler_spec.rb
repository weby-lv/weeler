require "spec_helper"

describe I18n::Backend::Weeler do

  describe "#interpolations" do

    it "can persist" do
      translation = I18n::Backend::Weeler::Translation.new(:key => 'foo', :value => 'bar', :locale => :en)
      translation.interpolations = %w(count name)
      translation.save
      expect(translation.valid?).to be(true)
    end

  end

  describe "#available_locales" do

    it "finds one locale" do
      expect(I18n.available_locales.count).to be(2)
    end

  end

  describe "#value" do

    it "returns boolean if translation boolean" do
      true_t = I18n::Backend::Weeler::Translation.create(:key => 'valid', :value => true, :locale => :en)
      false_t = I18n::Backend::Weeler::Translation.create(:key => 'invalid', :value => false, :locale => :en)

      expect(true_t.value).to be(true)
      expect(false_t.value).to be(false)
    end

    it "runs kernel if translation is_proc" do
      proc = I18n::Backend::Weeler::Translation.create(:key => 'valid', :value => "p 'This ir proc!'", :locale => :en, :is_proc => true)
      Kernel.should_receive(:p).with("This ir proc!")
      proc.value
    end

  end

  describe "#html?" do
    before(:all) do
      @html_key_translation = I18n::Backend::Weeler::Translation.create(:key => 'methods.body_html', :value => "Super duper", :locale => :en)
      @html_value_translation = I18n::Backend::Weeler::Translation.create(:key => 'methods.body', :value => "Super <b>duper</b>", :locale => :en)
      @html_fake_value_translation = I18n::Backend::Weeler::Translation.create(:key => 'methods.body_fake', :value => "Super < b", :locale => :en)
    end

    it "is true if key is html" do
      expect(@html_key_translation.html?).to be(true)
    end

    it "is true if value contains html" do
      expect(@html_value_translation.html?).to be(true)
    end

    it "is false if value not contains html" do

      expect(@html_fake_value_translation.html?).to be(false)
    end

  end

  describe "#lookup" do
    it "show warning" do
      I18n::Backend::Weeler::Translation.should_receive(:warn).with("[DEPRECATION] Giving a separator to Translation.lookup is deprecated. You can change the internal separator by overwriting FLATTEN_SEPARATOR.")
      I18n::Backend::Weeler::Translation.lookup("foo", "|")
    end
  end

  describe "groups" do

    before(:all) do
      I18n.backend.store_translations(:en, :group2 => { :test2 => 'bar' } )
      I18n.backend.store_translations(:en, :group1 => { :test => 'bar' })
      I18n.backend.store_translations(:en, :group1 => { :test3 => 'bar' })
      @groups = I18n::Backend::Weeler::Translation.groups
    end

    it "returns 2 groups" do
      expect(@groups.size).to eq(2)
    end

    it "returns ordered list" do
      expect(@groups[0]).to eq("group1")
      expect(@groups[1]).to eq("group2")
    end
  end

  describe "#store_translations" do
    it "store_translations does not allow ambiguous keys (1)" do
      I18n::Backend::Weeler::Translation.delete_all
      I18n.backend.store_translations(:en, :foo => 'foo')
      I18n.backend.store_translations(:en, :foo => { :bar => 'bar' })
      I18n.backend.store_translations(:en, :foo => { :baz => 'baz' })

      translations = I18n::Backend::Weeler::Translation.locale(:en).lookup('foo')
      expect(translations.map(&:value)).to eq(%w(bar baz))

      expect(I18n.t(:foo)).to eq({ :bar => 'bar', :baz => 'baz' })
    end

    it "store_translations does not allow ambiguous keys (2)" do
      I18n::Backend::Weeler::Translation.delete_all
      I18n.backend.store_translations(:en, :foo => { :bar => 'bar' })
      I18n.backend.store_translations(:en, :foo => { :baz => 'baz' })
      I18n.backend.store_translations(:en, :foo => 'foo')

      translations = I18n::Backend::Weeler::Translation.locale(:en).lookup('foo')
      expect(translations.map(&:value)).to eq(%w(foo))

      expect(I18n.t(:foo)).to eq('foo')
    end

    it "can store translations with keys that are translations containing special chars" do
      I18n.backend.store_translations(:es, :"Pagina's" => "Pagina's" )
      expect(I18n.t(:"Pagina's", :locale => :es)).to eq("Pagina's")
    end
  end

  describe "#lookup" do

    it "returns translation" do
      FactoryGirl.create(:translation)
      expect(I18n.t("title")).to eq("This is weeler")
    end

    context "missing translations" do

      context "exist in yml" do

        context "new translation" do

          it "persist it" do
            I18n.t('hello')
            expect(I18n::Backend::Weeler::Translation.locale(:en).find_by_key('hello').value).to eq(I18n.t('hello'))
          end

        end

        context "already stored" do
          before(:all) do
            FactoryGirl.create(:translation, key: "weeler.test.cms_title", locale: "en", value: nil)
          end

          it "saves the fallback backend value" do
            I18n.t('weeler.test.cms_title')
            expect(I18n::Backend::Weeler::Translation.locale(:en).find_by_key('weeler.test.cms_title').value).to eq("Weeler is cool")
          end
        end
      end

      it "persists the key" do
        I18n.t('hello')
        expect(I18n::Backend::Weeler::Translation.count).to eq(1)
        expect(I18n::Backend::Weeler::Translation.locale(:en).find_by_key('hello')).to_not be(nil)
      end

      it "lookup does not persist the key twice" do
        2.times { I18n.t('foo.bar.baz') }
        expect(I18n::Backend::Weeler::Translation.count).to eq(1)
        expect(I18n::Backend::Weeler::Translation.locale(:en).find_by_key('foo.bar.baz')).to_not be(nil)
      end

      it "lookup persists interpolation keys when looked up directly" do
        I18n.t('foo.bar.baz', :cow => "lucy" )
        translation_stub = I18n::Backend::Weeler::Translation.locale(:en).lookup('foo.bar.baz').first
        expect(translation_stub.interpolates?(:cow)).to be(true)
      end

      it "creates one stub per pluralization" do
        I18n.t('foo', :count => 999)
        translations = I18n::Backend::Weeler::Translation.locale(:en).where key: %w{ foo.zero foo.one foo.other }
        expect(translations.length).to be(3)
      end

      it "creates no stub for base key in pluralization" do
        I18n.t('foo', :count => 999)
        expect(I18n::Backend::Weeler::Translation.locale(:en).lookup("foo").count).to be(3)
        expect(I18n::Backend::Weeler::Translation.locale(:en).find_by(key: "foo")).to be(nil)
      end

      it "creates a stub when a custom separator is used" do
        I18n.t('foo|baz', :separator => '|')
        I18n::Backend::Weeler::Translation.locale(:en).lookup("foo.baz").first.update_attributes!(:value => 'baz!')
        expect(I18n.t('foo|baz', :separator => '|')).to eq('baz!')
      end

      it "creates a stub per pluralization when a custom separator is used" do
        I18n.t('foo|bar', :count => 999, :separator => '|')
        translations = I18n::Backend::Weeler::Translation.locale(:en).where key: %w{ foo.bar.zero foo.bar.one foo.bar.other }
        expect(translations.length).to be(3)
      end

      it "creates a stub when a custom separator is used and the key contains the flatten separator (a dot character)" do
        key = 'foo|baz.zab'
        I18n.t(key, :separator => '|')
        I18n::Backend::Weeler::Translation.locale(:en).lookup("foo.baz\001zab").first.update_attributes!(:value => 'baz!')
        expect(I18n.t(key, :separator => '|')).to eq('baz!')
      end

    end

  end

end
