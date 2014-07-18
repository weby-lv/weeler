module Weeler
  class ConfigurationController < BaseController
    def index; end
  private
    def set_current_menu_item
      @current_menu_item = "configuration"
    end
  end
end
