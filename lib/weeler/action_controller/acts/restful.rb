module Weeler
  module ActionController
    module Acts
      module Restful
        extend ActiveSupport::Concern

        module ClassMethods
          # Weeler action controller method.
          # It creates all restful actions for action controller. Create a controller for your
          # model (e.g. Post) what you want to administrate in weeler. Add method <tt>acts_as_restful Post</tt>
          # and permit params for your resource - option <tt>permit_params</tt>. Also you can paginate - add
          # option <tt>paginate</tt>
          # e.g.
          #
          #   class Weeler::PostController < Weeler::ContentController
          #     acts_as_restful Post, permit_params: [:title, :body], paginate: 50
          #   end
          #
          # It will handle <tt>:index</tt>, <tt>:new</tt>, <tt>:edit</tt>, <tt>:update</tt>,
          # <tt>:destroy</tt>, <tt>:order</tt>, <tt>:activation</tt> and <tt>:remove_image</tt> actions
          #
          # For permiting custom by role or permiting all params (permit!),
          # you must add block <tt>permit_params: -> (params) { params.require(:post).permit! }</tt>
          #
          # You should implement form file with your own active record attributes.
          # To do that, create <tt>_form.html.haml</tt> in <tt>views/weeler/_YOUR_RESOURCE_/_form.html.haml</tt>
          # where <tt>_YOUR_RESOURCE_</tt> is name of your resource.
          #
          # Also you can override all standart restful action view and implement, if you need,
          # <tt>_filter.html.haml</tt>
          #
          def acts_as_restful(active_record_model, options = {})
            before_action(:load_record, only: [:show, :edit, :update, :destroy, :remove_image])

            include InstanceMethodsOnActivation
            helper_method :item_humanized_name

            cattr_accessor :model do
              active_record_model
            end

            cattr_accessor :permited_params do
              options[:permit_params] if options.include? :permit_params
            end

            cattr_accessor :paginate do
              options[:paginate] if options.include? :paginate
            end

            cattr_accessor :order_by do
              options[:order_by] if options.include? :order_by
            end
          end
        end

        # These methods only activate if 'acts_as_restful' is called
        #
        module InstanceMethodsOnActivation

          def index
            @paginate = paginate
            @items = load_collection
            @items = @items.page(params[:page]).per(@paginate) if @paginate.present? && @paginate > 0
          end

          def new
            @item = model.new
            load_translations
          end

          def show
            render :edit
          end

          def edit
            load_translations
          end

          def order
            sort
          end

          def create
            @item = model.new(items_params)
            if @item.save
              after_create_action
            else
              render :action => 'new'
            end
          end

          def update
            if @item.update(items_params)
              after_update_action
            else
              render :action => 'edit'
            end
          end

          def destroy
            @item.destroy
            after_destroy_action
          end

          def remove_image
            if @item.image.present?
              @item.image.destroy
              @item.image_file_name = nil
              @item.save
            end
            redirect_to({ action: :edit, id: @item.id}, {:notice => "Image successfully removed"})
          end

        protected

          def items_params
            if permited_params.is_a? Proc
              permited_params.call(params)
            elsif permited_params.blank?
              warning_suggestion = params[parameterized_name.to_sym].is_a?(Hash) ? params[parameterized_name.to_sym].keys.map{ |k| k.to_sym } : "permit_params:"
              warn "[UNPERMITED PARAMS] To permit #{params[parameterized_name.to_sym].to_unsafe_h.inspect} params, add 'permit_params: #{warning_suggestion}' option to 'acts_as_restful'"
            else
              params.require(parameterized_name.to_sym).permit(permited_params)
            end
          end

          def collection; end

          def parameterized_name
            "#{model.to_s.underscore.downcase}"
          end

          def item_humanized_name
            "#{parameterized_name.humanize}"
          end

          def load_translations
            if @item.respond_to? :translations
              I18n.available_locales.each { |locale| @item.translations.find_or_initialize_by(locale: locale) }
            end
          end

        private

          def after_create_action
            redirect_to( after_create_path, {:notice => "Successfully created item"} )
          end

          def after_update_action
            redirect_to( after_update_path, {:notice => "Successfully updated item"} )
          end

          def after_destroy_action
            redirect_to( after_destroy_path, {:notice => "Successfully destroyed item"})
          end

          def after_create_path
            { action: :edit, id: @item.id }
          end

          def after_update_path
            { action: :edit, id: @item.id }
          end

          def after_destroy_path
            { action: :index }
          end

          def model
            model
          end

          def load_collection
            return @load_collection if @load_collection.present?
            if model
              if collection
                @load_collection = collection
              else
                @load_collection = model.all
                if order_by.present?
                  @load_collection.order(order_by)
                elsif model.new.has_attribute?(:sequence)
                  @load_collection.order(:sequence)
                else
                  @load_collection.order(created_at: :desc)
                end
              end
            end
          end

          def load_record
            @item = model.find(params[:id])
          end

          def sort
            items_sequence = URI.decode_www_form(params[:orders]).map{ |i| i[1] }
            items_sequence.each_with_index do |sequence_item_id, index|
              item = model.find_by id: sequence_item_id
              item.sequence = index
              item.save!
            end
            render plain: 'all ok'
          end

        end # Instance methods
      end
    end
  end
end
