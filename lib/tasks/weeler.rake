namespace :weeler do
  namespace :translations do
    desc "Remove all weeler i18n translation dublicates"
    task dedupe: :environment do
      I18n::Backend::Weeler::Translation.dedupe
    end
  end
end
