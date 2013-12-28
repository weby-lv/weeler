module Weeler
  class ConfigurationsController < BaseController
    def index; end
  private
    def set_current_menu_item
      @current_menu_item = "configurations"
    end
  end
end