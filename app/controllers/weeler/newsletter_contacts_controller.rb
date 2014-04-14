class Weeler::NewsletterContactsController < Weeler::ContentController
  
  def export
    respond_to do |format|
      format.csv { send_data collection.as_csv }
    end
  end

protected

  def collection
    items = active_record_class.order(created_at: :desc)
    items = items.where('full_name LIKE :query OR email LIKE:query', query: "%#{params[:query]}%") if params[:query].present?
    items = items.page(params[:page]).per(50)
    
    items    
  end
  
  def active_record_class
    Weeler::NewsletterContact
  end

  def newsletter_contact_params
    params.require(:weeler_newsletter_contact).permit(:full_name, :email)
  end

  def filter_options
    {}
  end
  helper_method :filter_options

end