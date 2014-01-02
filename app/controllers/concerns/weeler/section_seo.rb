module Weeler
  module SectionSeo
    extend ActiveSupport::Concern

    included do
      before_filter :initialize_seo_for_section
    end

  private
    
    def initialize_seo_for_section
      @seo = Weeler::Seo.find_or_create_by section: controller_name
    end

  end
end