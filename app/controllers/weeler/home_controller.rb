module Weeler
  class HomeController < BaseController
    def index; end
    def about; end
  private
    def set_current_menu_item
      @current_menu_item = "home"
    end
  end
end