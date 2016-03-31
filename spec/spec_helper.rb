require 'simplecov'
require 'coveralls'

# SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage(90)
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'capybara/rspec'
require 'database_cleaner'
require 'shoulda-matchers'

Rails.backtrace_cleaner.remove_silencers!
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  # config.color_enabled = true

  config.add_formatter(:progress)
  config.add_formatter(:html, 'rspec.html')

  config.include Rails.application.routes.url_helpers

  # FactoryGirl
  config.include FactoryGirl::Syntax::Methods
  
  Capybara.javascript_driver = :webkit

  # disable empty translation creation
  Weeler.create_missing_translations = true

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.before(:all) do
    I18n.available_locales = [:en, :lv]
  end

  config.after do
    # Timecop.return
    DatabaseCleaner.clean
  end
end

Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each { |f| require f }
