module Weeler
  module ActionController
    module Acts
      module Restful
        extend ActiveSupport::Concern

        module ClassMethods
          # Weeler action controller method. It creates all restful actions for action controller.
          # e.g.
          #
          #   class Weeler::PostController < Weeler::ContentController
          #     acts_as_restful Post, permit_params: [:title, :body], paginate: 50
          #   end
          #
          # It will create :index, :new, :edit, :update, :destroy, :order, :activation and :remove_image actions
          def acts_as_restful(active_record_model, options = {})
            before_filter(:load_record, only: [:show, :edit, :update, :destroy, :remove_image])

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
              redirect_to({ action: :edit, id: @item.id }, {:notice => "Successfully created item"})
            else
              render :action => 'new'
            end
          end

          def update
            if @item.update_attributes(items_params)
              redirect_to({ action: :edit, id: @item.id }, {:notice => "Successfully updated item"})
            else
              render :action => 'edit'
            end
          end

          def destroy
            @item.destroy
            redirect_to({ action: :index}, {:notice => "Successfully destroyed item"})
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
            if permited_params.present?
              params.require(item_humanized_name.to_sym).permit(permited_params)
            else
              params.require(item_humanized_name.to_sym).permit!
            end
          end

          def collection; end

          def item_humanized_name
            "#{model.to_s.underscore.humanize.downcase}"
          end

          def load_translations
            if @item.respond_to? :translations
              I18n.available_locales.each { |locale| @item.translations.find_or_initialize_by(locale: locale) }
            end
          end

        private

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
                if model.new.has_attribute?(:sequence)
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
            render :text => 'all ok'
          end

        end # Instance methods
      end
    end
  end
end
