module Weeler
  module FlashHelper
    def alert_class_for(flash_type)
      {
        :success => 'alert-success',
        :error => 'alert-danger',
        :alert => 'alert-warning',
        :notice => 'alert-info'
      }[flash_type.to_sym] || "alert-info"
    end
  end
end
