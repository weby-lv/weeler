Weeler.setup do |config|

  # Use Weeler I18n transaltion engine (ActiveRecord store).
  #
  # config.use_weeler_i18n = true
  # config.create_missing_translations = true # Create translation in database if it missing
  # config.empty_translation_acts_like_missing = true # Empty translations by default is treat like missing translation.

  # Require user method weeler use in before filter. (e.g. require_user)
  #
  # config.required_user_method = nil

  # You can define logout path (e.g. "/logout")
  #
  # config.logout_path = nil

  # Menu items in Content section. There you must create resources in app.
  #
  # config.content_menu_items = []

  # If you don't want to create model in your app and use only single page CMS, then you should use this property.
  # e.g. {about: ['about_us.title', 'about_us.about_text_html', 'about_us.our_company', 'about_us.our_company_text_html']}
  #
  #
  # config.static_sections = [] # Menu items in Content section under Static. Resourses uses I18n translaitons

  # Menu items in Administration section. There you must create resources in app.
  #
  # config.administration_menu_items = []

  # You can exclude translation groups from weeler administration
  # By default theres already excluded [:activerecord, :attributes, :helpers, :views, :i18n, :weeler]
  #
  # config.excluded_i18n_groups += ["number", "date", "scopes", "named_routes", "named_routes_path", "path_names", "errors", "routes"]

end
