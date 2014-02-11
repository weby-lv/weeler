module Weeler
  class TranslationsController < ConfigurationsController

    def index
      @translations = translations_by_params
      @translations = @translations.page(params[:page]).per(20)
      @groups = I18n::Backend::Weeler::Translation.groups
    end

    def new
      @translation = I18n::Backend::Weeler::Translation.new
    end

    def edit
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
    end

    def create
      @translation = I18n::Backend::Weeler::Translation.new(translation_params)

      if @translation.save
        redirect_to edit_weeler_translation_path(@translation), flash: {success: "Translation saved."}
      else
        flash.now[:error] = "Errors in saving."
        render :edit
      end
    end

    def update
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
      if @translation.update_attributes(translation_params)
        redirect_to edit_weeler_translation_path(@translation), flash: {success: "Translation updated."}
      else
        flash.now[:error] = "Errors in updating."
        render :edit
      end
    end

    def destroy
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
      @translation.destroy
      redirect_to weeler_translations_path, flash: {success: "Translation succesfully removed."}
    end

    def export
      respond_to do |format|
        format.xlsx do
          outstrio = StringIO.new
          outstrio.write(translations_by_params.as_xlsx_package.to_stream.read)
          send_data(outstrio.string, filename: "translations" + '.xlsx')
        end
      end
    end

    def import
      if params[:file].present?
        I18n::Backend::Weeler::Translation.import params[:file]
        redirect_to weeler_translations_path, flash: {success: "Translations succesfully imported."}
      else
        redirect_to weeler_translations_path, flash: {success: "No file choosen"}
      end
    end

  private

    def translation_params
      params.require(:i18n_backend_weeler_translation).permit([:locale, :key, :value, :is_proc, :interpolations => []])
    end

    def translations_by_params
      translations = I18n::Backend::Weeler::Translation.order("locale, key")

      translations = translations.where("key ILIKE ? OR value ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") if params[:query]
      translations = translations.where(locale: params[:filtered_locale]) if params[:filtered_locale].present?
      translations = translations.lookup(params[:group]) if params[:group].present?
      translations
    end

  end
end
