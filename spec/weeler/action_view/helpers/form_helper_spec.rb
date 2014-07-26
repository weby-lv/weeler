require 'spec_helper'

describe Weeler::ActionView::Helpers::FormHelper, :type => :helper do

  let(:resource)  { FactoryGirl.build :dummy_post }
  let(:helper)    { ActionView::Helpers::FormBuilder.new(:post, resource, self, {})}

  describe :image_upload_field do
    let(:output)    {
      helper.image_upload_field :image
    }

    it 'create file field' do
      expect(output).to include '<input class="form-control" id="post_image" name="post[image]" type="file" />'
    end

    it 'creates a label' do
      expect(output).to include '<label'
    end

    it "creates img preview tag" do
      expect(output).to include '<img alt="Original" src="/images/original.jpg" style="height: 80px;" />'
    end
  end

  describe :globalize_fields_for do
    let(:output)    {
      params = {"post" => {"translations_attributes" => {"1" => {"locale" => "lv", "title" => "foo" }}}}
      helper.globalize_fields_for :lv, params do |f|
        f.text_field :title
      end
    }

    it 'create translation id field' do
      expect(output).to include 'name="post[translations_attributes][1][id]"'
    end

    it "create translation locale field" do
      expect(output).to include 'name="post[translations_attributes][1][locale]" type="hidden" value="lv"'
    end

    it "create translation title text field" do
      expect(output).to include '<input id="post_translations_attributes_1_title" name="post[translations_attributes][1][title]" type="text" />'
    end
  end

end
