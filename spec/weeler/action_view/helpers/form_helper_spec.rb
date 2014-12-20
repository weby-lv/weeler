require 'spec_helper'

describe Weeler::ActionView::Helpers::FormHelper, :type => :helper do

  let(:resource)  { FactoryGirl.create :dummy_post }
  let(:helper)    { ActionView::Helpers::FormBuilder.new(:post, resource, self, {})}

  describe :image_upload_field do
    let(:output)    {
      helper.image_upload_field :image
    }

    it 'create file field' do
      expect(output).to include 'type="file"'
      expect(output).to include 'name="post[image]"'
    end

    it 'creates a label' do
      expect(output).to include '<label'
    end

    it "creates img preview tag" do
      expect(output).to include '<img'
      expect(output).to include 'src="'+ Rails.root.join('sample/original.png').to_s+'"'
      expect(output).to include 'style="height: 80px;"'
    end
  end

end
