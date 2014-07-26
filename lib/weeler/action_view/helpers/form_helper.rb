require "weeler/action_view/helpers/image_form_helper"
require "weeler/action_view/helpers/globalize_form_helper"

module Weeler
  module ActionView
    module Helpers
      module FormHelper
        extend ActiveSupport::Concern

        include ImageFormHelper
        include GlobalizeFormHelper
      end
    end
  end
end
