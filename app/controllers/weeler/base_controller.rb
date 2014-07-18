class Weeler::BaseController < Weeler::ApplicationController
  before_filter :set_current_menu_item
  before_filter :run_weeler_required_user_method

protected

  def default_url_options(options={})
    {}
  end

private

  def set_current_menu_item
    @current_menu_item = "content"
  end

  def run_weeler_required_user_method
    eval(Weeler.required_user_method.to_s) if Weeler.required_user_method.present?
  end
end
