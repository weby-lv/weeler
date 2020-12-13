lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weeler/version'

Gem::Specification.new do |spec|
  spec.name          = 'weeler'
  spec.version       = Weeler::VERSION::STRING
  spec.authors       = ['Artūrs Braučs', 'Artis Raugulis']
  spec.email         = ['arturs.braucs@gmail.com', 'artis@devart.lv']
  spec.description   = %q{CMS for weby.lv projects.}
  spec.summary       = %q{CMS for weby.lv projects.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 6.0'

  spec.add_dependency 'globalize'
  spec.add_dependency 'i18n'

  spec.add_dependency 'haml'

  spec.add_dependency 'kaminari'

  spec.add_dependency 'jquery-ui-rails'
  spec.add_dependency 'rails-settings-cached'

  spec.add_dependency 'caxlsx'
  spec.add_dependency 'roo'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails', '~> 4.0.0'
  spec.add_development_dependency 'webrat'

  if RUBY_PLATFORM == 'java'
    spec.add_development_dependency 'activerecord-jdbcpostgresql-adapter'
  else
    spec.add_development_dependency 'pg'
  end

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'shoulda-matchers'

  spec.add_development_dependency 'pry'
end
