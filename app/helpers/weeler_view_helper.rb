module WeelerViewHelper
  def navbar_link_to title, link
  	id = title.parameterize
  	return %{<li class="#{id}#{' active' if @current_menu_item == id}">
            <a href="#{link}">#{title}</a>
          </li>}.html_safe
  end
end