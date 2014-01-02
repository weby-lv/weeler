class RedactorRails::DocumentsController < ApplicationController
  before_filter :redactor_authenticate_user!

  def index
    @documents = RedactorRails.document_model.all
  end

  def create
    @document = RedactorRails.document_model.new

    file = params[:file]
    @document.data = RedactorRails::Http.normalize_param(file, request)
    if @document.save
      render :text => { :filelink => @document.url, :filename => @document.filename }.to_json
    else
      render :nothing => true
    end
  end

  private

  def redactor_authenticate_user!
    if RedactorRails.document_model.new.respond_to?(RedactorRails.devise_user)
      super
    end
  end
end