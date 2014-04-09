module Weeler

  module FormHelper
    def self.included(base)
      ActionView::Helpers::FormBuilder.instance_eval do
        include FormBuilderMethods
      end
    end

    module FormBuilderMethods
      def image_upload_field(name, size_info: "200x80", image_url_method: "image.url(\"normal\")", image_method: "image", info_size: nil)
        self.multipart = true
        size_info = info_size if info_size.present?
        buffer = @template.label(@object_name, name, class: "col-lg-2 col-md-2 control-label")
        buffer += @template.content_tag :div, class: "col-lg-5 col-md-5" do
          sub_buffer = @template.content_tag :div, class: "row" do
            @template.content_tag :div, class: "col-lg-12 col-md-12" do
              @template.file_field @object_name, name, :class => 'form-control'
            end
          end
          sub_buffer += @template.content_tag :div, class: "row" do
            @template.content_tag :div, class: "col-lg-12 col-md-12" do
              "Size should be #{size_info}"
            end
          end
          sub_buffer
        end
        buffer += @template.content_tag :div, class: "col-lg-5 col-md-5" do
          if @object.instance_eval(image_method).present?
            sub_buffer = @template.content_tag :div, class: "row" do
              @template.content_tag :div, class: "col-lg-12 col-md-12" do
                @template.image_tag @object.instance_eval(image_url_method), style: "height: 80px;"
              end
            end
            build_route = true
            begin
              @template.link_to("Remove", action: "remove_image")
            rescue Exception => e
              build_route = false
            end
            if build_route
              sub_buffer += @template.content_tag :div, class: "row" do
                @template.content_tag :div, class: "col-lg-12 col-md-12" do
                  @template.link_to("Remove", action: "remove_image")
                end
              end
            end
            sub_buffer
          end
        end
        buffer
      end
    end
  end
end
