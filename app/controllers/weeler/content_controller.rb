module Weeler
  class ContentController < BaseController
    def index
      render :welcome
    end

  protected
    def set_current_menu_item
      @current_menu_item = "content"
    end
  end
end
