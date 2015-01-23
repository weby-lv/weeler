require 'spec_helper'

describe Weeler::ActionView::Helpers::FormHelper, :type => :helper do

  let(:resource)  { FactoryGirl.create :dummy_post }
  let(:helper)    { ActionView::Helpers::FormBuilder.new(:post, resource, self, {})}

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
  
  context 'change size info and image url method' do
    
    it 'works on none java platforms' do
      expect(helper.image_upload_field(:image, image_url_method: "image.url('small')", size_info: "200x100")).to include("200x100")
    end

  end

end
