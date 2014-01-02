class Weeler::SeosController < Weeler::BaseController
  
  def update
    @seo = Weeler::Seo.find(params[:id])

    if @seo.update_attributes(seos_params)
      redirect_to request.referer, notice: "Successfully updated SEO data."
    else
      redirect_to request.referer, notice: "Something went wrong."
    end

  end

private

  def seos_params
    params.require(:weeler_seo).permit(:title, :description, :keywords, :section, translations_attributes: [:id, :locale, :title, :description, :keywords])
  end

end