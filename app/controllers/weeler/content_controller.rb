module Weeler
  class ContentController < BaseController

    def index
      @items = loaded_collection
    end

    def new
      @item = active_record_class.new
    end

    def edit
      @item = active_record_class.find(params[:id])
    end

    def order
      sort(loaded_collection)
    end

    def create
      @item = active_record_class.new(items_params)
      if @item.save
        redirect_to({ action: :index}, {:notice => "Successfully created item"})
      else
        render :action => 'new'
      end
    end

    def update
      @item = active_record_class.find(params[:id])
      if @item.update_attributes(items_params)
        redirect_to({ action: :index}, {:notice => "Successfully updated item"})
      else
        render :action => 'edit'
      end
    end

    def destroy
      @item = active_record_class.find(params[:id])
      @item.destroy
      redirect_to({ action: :index}, {:notice => "Successfully destroyed item"})
    end

    def remove_image
      @item = active_record_class.find(params[:id])
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

  end
end