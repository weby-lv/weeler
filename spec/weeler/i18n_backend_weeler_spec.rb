require "spec_helper"

describe I18n::Backend::Weeler do

  before(:all) do
    # enable empty translation creation
    Weeler.create_missing_translations = true
  end

  after(:all) do
    # disable empty translation creation
    Weeler.create_missing_translations = false
  end

  before do
  end

end