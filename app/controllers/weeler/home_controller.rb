module Weeler
  class HomeController < BaseController
    def index; end
    def about
      @current_menu_item = "about"
    end
  end
end