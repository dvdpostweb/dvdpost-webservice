class CustomPaginationRenderer < WillPaginate::LinkRenderer
  def to_html
    links = @options[:page_links] ? windowed_links : []    
    html = links.join(@options[:separator])
    @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
  end  
end
