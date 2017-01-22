## 1.5.4

* Using RailsSettings::CachedSettings instead of RailsSettings::Base

## 1.5.3

* Rails depricated table exists, using data source exists instead
* Using RailsSettings::Base instead of RailsSettings::CachedSettings

## 1.5.2

* Added translation filter by created at
* Updated bootstrap to v3.3.6
* Fixed issue when bootstrap fonts (glyphicons) where not loaded
* Removed sass-twitter-bootstrap-rails dependency
* Added bootstrap date / time picker

### Contributors

* Artis Raugulis

## 1.5.1

* Fixed version number

### Contributors

* Artis Raugulis

## 1.4.0

* Added translation usage stats
* Fixed a transliteration bug

### Contributors

* Artis Raugulis

## 1.5.0

* Added Lock
* Added translation usage stats export
* Dropped jruby support
* Dropped rbx suport

## 1.4.0

* Added translation usage stats
* Fixed a transliteration bug

### Contributors

* Artis Raugulis

## 1.3.0

### Features & Enhancements

* Added option to customize what happens after successful create, update, destroy

### Contributors

* Artis Raugulis

## 1.2.0

### Features & Enhancements

* Added option to override acts as restful create, update, destroy redirect path

### Contributors

* Artis Raugulis


## 1.1.1

### Features & Enhancements

* Improved working with translations by removing rowlink.

### Contributors

* Artis Raugulis

## 1.1.0

### Features & Enhancements

* Add JRuby and Rubinius support.
* 'image_upload_field' accept only hash options (for JRuby support).
* Add 'empty_translation_acts_like_missing' config. Empty translations by
  default is treat like missing translation.

### Bug Fixes

* Translation html safe output bug fixed (Rails 4.2 bug)

### Contributors

* Arturs Braucs

## 1.0.4

### Bug Fixes

* Fixed seoable bug that called not weeler function.

### Contributors

* Arturs Braucs

## 1.0.3

### Features & Enhancements

* Updated bootstrap to v3.3.1

### Contributors

* Artis Raugulis

## 1.0.2

### Bug Fixes

* Require jquery turbolinks
* Update dependencies
* Using boostrap flash instead jquery notify

### Contributors

* Arturs Braucs

## 1.0.1

### Bug Fixes

* Fixed turbo links not workin
* Fixed seo translation wrong locale
* Fixed empty image with image_upload_field

### Contributors

* Artis Raugulis

## 1.0.0

### Features & Enhancements

* Refactored <tt>image_upload_field</tt>
* Tested on production apps.
* Add <tt>Weeler.translations</tt> method for accessing I18n translation model.

### Contributors

* Arturs Braucs

## 1.0.0.alpha3

### Bug Fixes

* Fixed translation helper bug. No instance session (only fake one) in mailer templates.

### Contributors

* Arturs Braucs

## 1.0.0.alpha2

* Fixed a turbolinks bug

### Contributors

* Artis Raugulis

## 1.0.0.alpha1

Starting prepering for 1.0.0 version

### Features & Enhancements
* Removed <tt>globalize_fields_for</tt> implementation
* Write tests for showint translaiton keys
* Improving documentation coverage.

### Contributors

* Arturs Braucs

## 0.2.5

* Option for showing translation keys, for easier translation key lookup

### Contributors

* Arturs Braucs, Artis Raugulis

## 0.2.4

* Fixed a bug when using two words in a model name caused a missing required param

### Contributors

* Artis Raugulis

## 0.2.3

* Support for multileve seo keys
* Order by in acts as restful
* Removed unused code
* Version indicator

### Contributors

* Artis Raugulis

## 0.2.2

### Features & Enhancements

* 'acts_as_restful' - no more unpirmetted by default

### Contributors

* Arturs Braucs

## 0.2.1

### Features & Enhancements

* Remove GlobilzeFormBuilder and add globalize_fields_for in ActionView FormBuilder. Also method is depricated and will be removed in 1.0.0 version.
* Refacture Weeler image_upload_field and add some tests.

### Contributors

* Arturs Braucs

## 0.2.0

### Features & Enhancements

* Add administration section
* Refactured app section
* Create acts_as_restful
* Improve test covarage
* Refactured lib section
* Remove Newsletter section
* Weeler.menu_items -> Weeler.content_menu_items

### Contributors

* Arturs Braucs

## 0.1.2

### Bug Fixes

* Fixed routing error for Rails 4.1

### Contributors

* Arturs Braucs

## 0.1.1

### Features & Enhancements

* Cache weeler backend translations
* Exclude unused keys in translations
* Static sections
* SEO in seperate sections

### Contributors

* Arturs Braucs

## 0.1.0

### Features & Enhancements

* Improve menu item routing. Now it is possible to add item with params, custom action or scope.
* Update menu structure. Add content and configurations section.
* Add SEO module for static and dynamic SEO content.
* Add slug generator module.
* Add dynamic sort feature.
* Add error_messages, list, sortable_list, section_seo templates (must extend content controller to use those).
* Improve install generator (add assets, migrations for SEO). Also add SEO generator.
* Append weeler assets to precompile path.
* Adds existing fallback backend translation data in database (I18n::Backend::Weeler)

### Contributors

* Arturs Braucs

## 0.0.4

### Features & Enhancements

* Refacture translations import and export. Moved logic to lib/i18n/backend/weeler .
* Append routes and controller example generators.
* Increase test covorage.

### Bug Fixes

* Fixed export multiply export bug.
* Change file browser button to fix dependency error.

### Contributors

* Arturs Braucs

## 0.0.3

### Bug Fixes

* Remove routes isolation. That crashed all backend. :(

### Contributors

* Arturs Braucs

## 0.0.2

### Features & Enhancements

* Implement I18n Active Record backend
* Add GUI for frontend - bootstrap
* List, add, edit application I18n translations
* Import and export translation excel (xlsx) files
* Implement weeler routes

### Test Suite

* I18n backend tests
* Weeler routes tests

Translations not tested yet

### Bug Fixes

### Contributors

* Arturs Braucs

## 0.0.1

* Initial release

### Features & Enhancements

* Gem structure
* Rails dependencies

### Bug Fixes

### Test Suite

* RSpec

### Contributors

* Arturs Braucs
