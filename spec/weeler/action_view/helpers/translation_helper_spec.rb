require 'spec_helper'

describe Weeler::ActionView::Helpers::TranslationHelper, :type => :helper do

  describe :translate do
    let(:output)    {
      helper.translate "not.existing.key"
    }

    it 'renders key' do
      Settings.show_translation_keys = "on"
      expect(output).to eq('not.existing.key')
    end
  end

end
