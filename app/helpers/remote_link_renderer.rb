class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

protected
  def page_link(page, text, attributes = {})
    
    @template.link_to(text, "#{@remote[:url]}?#{@remote[:param_name]}=#{page}", attributes)
  end
end