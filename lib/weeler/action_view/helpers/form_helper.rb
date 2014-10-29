require "weeler/action_view/helpers/image_form_helper"

module Weeler
  module ActionView
    module Helpers
      module FormHelper
        extend ActiveSupport::Concern

        include ImageFormHelper
      end
    end
  end
end
