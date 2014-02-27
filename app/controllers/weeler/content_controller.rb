module Weeler
  class ContentController < BaseController
    before_filter :load_record, only: [:show, :edit, :update, :destroy, :remove_image]

    def index
      @items = loaded_collection
    end

    def new
      @item = active_record_class.new
    end

    def show; end

    def edit; end

    def order
      sort(active_record_class)
    end

    def create
      @item = active_record_class.new(items_params)
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

    def items_params; end

    def collection; end

    def item_humanized_name
      "#{active_record_class.to_s.underscore.humanize.downcase}"
    end
    helper_method :item_humanized_name

  private

    def active_record_class
      nil
    end

    def loaded_collection
      return @loaded_collection if @loaded_collection.present?
      if active_record_class
        if collection
          @loaded_collection = collection
        else
          @loaded_collection = active_record_class.all
          if active_record_class.new.has_attribute?(:sequence)
            @loaded_collection.order(:sequence)
          else
            @loaded_collection.order(created_at: :desc)
          end
        end
      end
    end

    def load_record
      @item = active_record_class.find(params[:id])
    end

  end
end
