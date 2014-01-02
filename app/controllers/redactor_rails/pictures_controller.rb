class RedactorRails::PicturesController < ApplicationController
  before_filter :redactor_authenticate_user!

  def index
    @pictures = RedactorRails.picture_model.all
    render :json => @pictures.to_json
  end

  def create
    @picture = RedactorRails.picture_model.new

    file = params[:file]
    @picture.data = RedactorRails::Http.normalize_param(file, request)
    if @picture.save
      render :text => { :filelink => @picture.url }.to_json
    else
      render :nothing => true
    end
  end

  private

  def redactor_authenticate_user!
    if RedactorRails.picture_model.new.respond_to?(RedactorRails.devise_user)
      super
    end
  end
end