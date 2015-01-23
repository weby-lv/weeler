module Weeler
  module ActionView
    module Helpers
      module ImageFormHelper

        # Weeler action view helper method.
        # It creates file upload field with info and preview for image.
        #
        # e.g.
        #
        #   <%= f.image_upload_field :image, size_info: "270x294" %>
        #
        # It creates:
        #   <div class="col-lg-10 col-md-10">
        #     <label class="col-lg-2 col-md-2 control-label" for="object_image">Image</label><div class="col-lg-5 col-md-5"><div class="row"><div class="col-lg-12 col-md-12"><input class="form-control" id="object_image" name="object[image]" type="file"></div></div><div class="row"><div class="col-lg-12 col-md-12">Size should be 270x294</div></div></div><div class="col-lg-5 col-md-5"><div class="row"><div class="col-lg-12 col-md-12"><img alt="Name" src="/images/name.jpg" style="height: 80px;"></div></div></div>
        #   </div>
        #
        # If you use another image handler than Paperclip, you can also pass <tt>image_url_method</tt> for image preview.
        #
        # Also with remove_image action in controller and route for that,
        # it removes only image from object.
        
        if RUBY_PLATFORM == 'java'
          p "Ruby platfor is #{RUBY_PLATFORM}" 
          def image_upload_field(name, size_info = "200x80", image_url_method = nil)
          
          end
        
        else

          p "Ruby platfor is #{RUBY_PLATFORM}" 
          def image_upload_field(name, size_info: "200x80", image_url_method: nil)
            
          end
        end



        def call_image_upload_field(name, size_info = "200x80", image_url_method = nil)
          self.multipart = true

          image_url_method = "#{name.to_s}.url(\"original\")" unless image_url_method.present?

          buffer = @template.label(@object_name, name, :class => "col-lg-2 col-md-2 control-label")

          buffer += image_upload_field_file_block name, size_info
          buffer += image_upload_field_preview_block name, image_url_method if File.exist?(@object.instance_eval(image_url_method))

          buffer
        end

        private

          def image_upload_field_file_block name, size_info
            @template.content_tag :div, :class => "col-lg-5 col-md-5" do
              sub_buffer = @template.content_tag :div, :class => "row" do
                @template.content_tag :div, :class => "col-lg-12 col-md-12" do
                  @template.file_field @object_name, name, :class => 'form-control'
                end
              end
              sub_buffer += @template.content_tag :div, :class => "row" do
                @template.content_tag :div, :class => "col-lg-12 col-md-12" do
                  "Size should be #{size_info}"
                end
              end
              sub_buffer
            end
          end

          def image_upload_field_preview_block name, image_url_method
            @template.content_tag :div, :class => "col-lg-5 col-md-5" do
              if @object.instance_eval(name.to_s).present?
                sub_buffer = @template.content_tag :div, :class => "row" do
                  @template.content_tag :div, :class => "col-lg-12 col-md-12" do
                    @template.image_tag @object.instance_eval(image_url_method), :style => "height: 80px;"
                  end
                end

                build_route = true
                begin
                  @template.link_to("Remove", action: "remove_image")
                rescue Exception => e
                  build_route = false
                end

                if build_route
                  sub_buffer += @template.content_tag :div, :class => "row" do
                    @template.content_tag :div, :class => "col-lg-12 col-md-12" do
                      @template.link_to("Remove", :action => "remove_image")
                    end
                  end
                end
                sub_buffer
              end
            end
          end

      end
    end
  end
end
