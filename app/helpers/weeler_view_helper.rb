module WeelerViewHelper
  def navbar_link_to title, link, options={}
  	id = title.parameterize
  	html = %{<li class="#{id}#{' active' if @current_menu_item == id}"><a href="#{link}">}
	if options[:icon]
		# Available icons can be seen here: http://getbootstrap.com/components/#glyphicons
		html << %{<span class="glyphicon glyphicon-#{options[:icon]}"#{' style="vertical-align: -1px"' if string_contains_char_from_array title, ['q','y','p','g','j']}></span>}
	end
  	html << %{#{title}</a></li>}
  	return html.html_safe
  end

  def string_contains_char_from_array text, chars
  	return !(text.chars.to_a & chars).empty?
  end
end