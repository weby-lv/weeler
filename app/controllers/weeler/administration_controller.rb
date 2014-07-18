module Weeler
  class AdministrationController < ContentController
    def index
      render :welcome
    end
  private
    def set_current_menu_item
      @current_menu_item = "administration"
    end
  end
end
