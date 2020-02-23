class Weeler::SettingsController < Weeler::ConfigurationController
  def index
    # to get all items for render list
    @settings = Settings.unscoped
  end

  def update
    @setting = Settings.unscoped.find(params[:id])
    if @setting.update(setting_params)
      redirect_to weeler_settings_path, flash: {success: "Setting updated."}
    else
      flash.now[:error] = "Errors in updating."
      render :index
    end
  end
protected
  def setting_params
    params.require(:settings).permit([:value])
  end

end
