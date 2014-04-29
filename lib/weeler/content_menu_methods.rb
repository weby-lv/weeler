module Weeler::ContentMenuMethods

  # Add menu item for resource
  def add_menu_item resource
    Weeler.menu_items << {name: resource.to_s.capitalize, weeler_path: resource} unless Weeler.menu_items.select{ |item| item[:name] == resource.to_s.capitalize }.size > 0
  end

end
