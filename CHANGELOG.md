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
