class Setting < RailsSettings::Base
  field :i18n_updated_at, type: :string

  Weeler.settings_fields.each do |field_options|
    field field_options[:name], field_options.except(:name)
  end
end
