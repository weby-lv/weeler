module Weeler
  class BaseController < ApplicationController
    before_filter :set_current_menu_item
    before_filter :run_weeler_required_user_method

  protected

    # Use for index sorting
    #
    def sort(klass)

      # parse string to know the records order TODO: refactor!
      items_sequence = params[:orders][8..-1].split("&order[]=")

      items_sequence.each_with_index do |sequence_item_id, index|
        item = klass.find_by id: sequence_item_id
        item.sequence = index
        item.save!
      end

=begin
      items.each do |item|
        if item.sequence.nil? || item.sequence != items_sequence.index("#{item.id}")
          item.sequence = items_sequence.index("#{item.id}")
          item.save!
        end
      end
=end
      render :text => 'all ok'
    end

  private

    def set_current_menu_item
      @current_menu_item = "content"
    end

    def run_weeler_required_user_method
      eval(Weeler.required_user_method.to_s) if Weeler.required_user_method.present?
    end
  end
end
