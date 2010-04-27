module ProductsHelper
  def hide_wishlist_if_seen
    session[:indicator_stored] || !current_customer ? javascript_tag("$('#indicator-tips').hide();") : ''
  end

  def rating_image(product,rating, rating_customer, background, type='DVD_NORM')
    images = ""
    if rating_customer
      name = "star-voted"
      class_name = ''
    else
      name = "star"
      class_name = 'star'
    end
    name = 'dark_' + name if background == :black

    5.times do |i|
      id = "#{product.to_param.to_s}_#{(i+1).to_s}"
      if rating >= 2
        images += image_tag "#{name}-on.jpg", :id => id, :product_id => product.to_param.to_s, :nb => (i+1), :class => class_name, :type => background.to_s + 'full'
      elsif rating.odd?
        images += image_tag "#{name}-half.jpg", :id => id, :product_id => product.to_param.to_s, :nb => (i+1), :class => class_name, :type => background.to_s + 'half'
      else
        images += image_tag "#{name}-off.jpg", :id => id, :product_id => product.to_param.to_s, :nb => (i+1), :class => class_name, :type => background.to_s + 'off'
      end
      rating -= 2
      rating = 0 if rating < 0
    end 
    images
  end

  def available_on_other_media(product)
    unless product.series?
      if product.dvd?
        bluray = Product.by_media(:bluray).by_imdb_id(product.imdb_id).by_language(I18n.locale).first
        link_to('Disponible en Blu-ray Disc', product_path(:id => bluray), :id => 'bluray-btn', :class => 'like-btn') if bluray
      elsif product.bluray?
        dvd = Product.by_media(:dvd).by_imdb_id(product.imdb_id).by_language(I18n.locale).first
        link_to('Disponible en DVD', product_path(:id => dvd), :id => 'dvd-btn', :class => 'like-btn') if dvd
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
        link_to('Disponible dans une autre langue', product_path(:id => product.products_other_language), :id => 'dispo-btn_'+I18n.locale.to_s+'_nl', :class => 'dispo-btn like-btn')  
      else
        link_to('Disponible dans une autre langue', product_path(:id => product.products_other_language), :id => 'dispo-btn_'+I18n.locale.to_s+'_fr', :class => 'dispo-btn like-btn')  
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
          content += "<p id=\"oscars\">#{link_to 'Lire la suite', product_awards_path(:product_id => product.to_param)}</p>"
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
end
