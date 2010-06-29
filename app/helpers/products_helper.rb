module ProductsHelper
  def hide_wishlist_if_seen
    session[:indicator_stored] || !current_customer ? javascript_tag("$('#indicator-tips').hide();") : ''
  end

  def rating_review_image_links(product,  replace=nil)
    links = []
    5.times do |i|
      i += 1
      links << rating_review_image_link(product, i, replace)
    end
    links
  end
  
  def rating_image_links(product, background=nil, replace=nil)
    rating = product.rating(current_customer)
    links = []
    5.times do |i|
      i += 1
      links << rating_image_link(product, rating, i, background, replace)
      rating -= 2
    end
    links
  end

  def rating_review_image_link(product, value, replace)
    name = 'star-voted'
    class_name = 'star'
    image_name = "#{name}-off.jpg"

    image = image_tag(image_name, :class => class_name, :id => "star_#{product.to_param}_#{value}", :name => image_name)
    link_to(image, product_rating_path(:product_id => product, :value => value, :background => :white, :replace => replace))
  end
  
  def rating_image_link(product, rating, value, background=nil, replace=nil)
    if current_customer.has_rated?(product)
      name = 'star-voted'
      class_name = ''
    else
      name = 'star'
      class_name = 'star'
    end
    name = "black-#{name}" if background == :black

    image_name = if rating >= 2
      "#{name}-on.jpg"
    elsif rating == 1
      "#{name}-half.jpg"
    else
      "#{name}-off.jpg"
    end

    image = image_tag(image_name, :class => class_name, :id => "star_#{product.to_param}_#{value}", :name => image_name)
    link_to(image, product_rating_path(:product_id => product, :value => value, :background => background, :replace => replace))
  end

  def available_on_other_media(product)
    unless product.series?
      if product.dvd?
        bluray = Product.by_media(:bluray).by_imdb_id(product.imdb_id).by_language(I18n.locale).first
        link_to(t('.dispo_bluray'), product_path(:id => bluray), :id => 'bluray-btn') if bluray
      elsif product.bluray?
        dvd = Product.by_media(:dvd).by_imdb_id(product.imdb_id).by_language(I18n.locale).first
        link_to(t('.dispo_dvd'), product_path(:id => dvd), :id => 'dvd-btn') if dvd
      else
        ''
      end
    else
      ''
    end
  end

  def available_on_other_language(product)
    if product.products_other_language.to_i > 0 
      if product.languages.preferred.include?(Language.find(1))
        link_to(t('.dispo_nl'), product_path(:id => product.products_other_language), :id => 'dispo-btn', :class => 'dispo-btn')  
      else
        link_to(t('.dispo_fr'), product_path(:id => product.products_other_language), :id => 'dispo-btn', :class => 'dispo-btn')  
      end
    end
  end

  def product_description_text(product)
    product.description.nil? || product.description.text.nil? ? '' : truncate(product.description.text, :length => 300)
  end

  def product_image_tag(source, options={})
    image_tag (source || File.join(I18n.locale.to_s, 'image_not_found.gif')), options
  end

  def awards(product)
    content = ''
    if !product.description.products_awards.empty?
      awards = product.description.products_awards.split('<br>')
      if count_awards(awards) > 3
          content += '<p id ="oscars_text">'
          3.times do |i|
            content += "#{awards[i]}<br />"
          end
          content += '</p>'
          content += "<p id=\"oscars\">#{link_to t('.read_more'), product_awards_path(:product_id => product.to_param)}</p>"
      else
        content += "<p>#{product.description.products_awards}</p>"
      end
    end 
  end

  def count_awards(awards)
    count = 0
    awards.each do |award|
      if !award.empty?
        count += 1
      end
    end
    count
  end

  def filter_checkbox_tag(attribute, sub_attribute)
    check_box_tag "#{attribute}[#{sub_attribute}]", 1, params[attribute] && params[attribute][sub_attribute]
  end
  
  def title()
    title = t('.director') +' : '+ Director.find(params[:director_id]).name if params[:director_id] && !params[:director_id].empty?
    title = t('.actor') +' : '+ Actor.find(params[:actor_id]).name if params[:actor_id] && !params[:actor_id].empty?
    title = t('.recommendation') if params[:recommended]
    title = t('.categorie') +' : '+ Category.find(params[:category_id]).descriptions.by_language(I18n.locale).first.name if params[:category_id] && !params[:category_id].empty?
    title = t('.top') +' : '+  ProductList.find(params[:top_id]).name if params[:top_id] && !params[:top_id].empty?
    title = t('.theme') +' : '+  ProductList.find(params[:theme_id]).name if params[:theme_id] && !params[:theme_id].empty?
    title = t('.search') +' : '+ params[:search] if params[:search]
    title
  end

  def title_add_to_wishlist(type_text)
    if type_text == :short
      t('products.wishlist.short_add')
    else
      t('products.wishlist.add')
    end
  end 
end
