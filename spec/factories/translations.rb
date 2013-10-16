FactoryGirl.define do
 factory :translation, class: I18n::Backend::Weeler::Translation do
    locale "en"
    key "title"
    value "This is weeler"
  end
end
