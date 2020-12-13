class Weeler::SettingsController < Weeler::ConfigurationController
  HIDDEN_SETTINGS_KEYS = %w[i18n_updated_at].freeze

  def index
    @settings = Setting.all.order(:id).where.not(var: HIDDEN_SETTINGS_KEYS)
  end

  def create
    @setting = Setting.new(create_setting_params)

    if @setting.save
      redirect_to weeler_settings_path, flash: { success: 'Setting created.' }
    else
      flash.now[:error] = 'Errors on creating.'
      render :index
    end
  end

  def update
    @setting = Setting.find(params[:id])

    if @setting.update(update_setting_params)
      redirect_to weeler_settings_path, flash: { success: 'Setting updated.' }
    else
      flash.now[:error] = 'Errors on updating.'
      render :index
    end
  end

  protected

  def create_setting_params
    params.require(:setting).permit(:var, :value)
  end

  def update_setting_params
    params.require(:setting).permit(:value)
  end
end
