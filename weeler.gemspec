# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weeler/version'

Gem::Specification.new do |spec|
  spec.name          = 'weeler'
  spec.version       = Weeler::VERSION::STRING
  spec.authors       = ['Artūrs Braučs',  'Artis Raugulis']
  spec.email         = ['arturs.braucs@gmail.com', 'artis@devart.lv']
  spec.description   = %q{CMS for weby.lv projects.}
  spec.summary       = %q{CMS for weby.lv projects.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 4'
  spec.add_dependency 'i18n'
  spec.add_dependency 'rails-settings-cached'
  spec.add_dependency 'globalize'

  spec.add_dependency 'kaminari'
  spec.add_dependency 'haml'
  spec.add_dependency 'sass-twitter-bootstrap-rails'
  spec.add_dependency 'jquery-turbolinks'
  spec.add_dependency 'jquery-ui-rails'

  spec.add_dependency 'axlsx'
  spec.add_dependency 'roo'
  spec.add_dependency 'sanitize'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'webrat'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'factory_girl_rails'
  if RUBY_PLATFORM == 'java'
    spec.add_development_dependency 'activerecord-jdbcsqlite3-adapter'
  else
    spec.add_development_dependency 'sqlite3'
  end
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'coveralls'

end
