module Weeler
  class ContentController < BaseController
    @@ar_klass = nil

    def index
      @items = loaded_collection
    end

    def new
      @item = @@ar_klass.new
    end

    def edit
      @item = @@ar_klass.find(params[:id])
    end

    def order
      sort(loaded_collection)
    end

    def create
      @item = @@ar_klass.new(items_params)
      if @item.save
        redirect_to({ action: :index}, {:notice => "Successfully created item"})
      else
        render :action => 'new'
      end
    end

    def update
      @item = @@ar_klass.find(params[:id])
      if @item.update_attributes(items_params)
        redirect_to({ action: :index}, {:notice => "Successfully updated item"})
      else
        render :action => 'edit'
      end
    end

    def destroy
      @item = @@ar_klass.find(params[:id])
      @item.destroy
      redirect_to({ action: :index}, {:notice => "Successfully destroyed item"})
    end

  protected
      
    def items_params; end

    def collection; end

    def item_humanized_name
      "#{@@ar_klass.to_s.underscore.humanize.downcase}"
    end
    helper_method :item_humanized_name

  private

    def loaded_collection
      return @loaded_collection if @loaded_collection.present?
      if @@ar_klass
        if collection.present?
          @loaded_collection = collection
        else
          @loaded_collection = @@ar_klass.all
          if @@ar_klass.new.has_attribute?(:sequence)
            @loaded_collection.order(:sequence)
          else
            @loaded_collection.order(created_at: :desc)
          end
        end
      end
    end

  end
end