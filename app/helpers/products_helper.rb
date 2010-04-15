module ProductsHelper
  def hide_wishlist_if_seen
    session[:indicator_stored] ? javascript_tag("$('#indicator-tips').hide();") : ''
  end

  def rating_image(product,rating, rating_customer, type='DVD_NORM')
    images = ""
    if rating_customer
      name = "star-voted"
      class_name = ''
    else
      name = "star"
      class_name = 'star'
    end
    5.times do |i|
       id = product.to_param.to_s+'_'+(i+1).to_s
      if rating >= 2
        images += image_tag "#{name}-on.jpg", :id => id, :product_id =>product.to_param.to_s, :nb => (i+1), :class => class_name, :type => 'full'
      elsif rating.odd?
        images += image_tag "#{name}-half.jpg", :id => id, :product_id =>product.to_param.to_s, :nb => (i+1), :class => class_name, :type => 'half'
      else
        images += image_tag "#{name}-off.jpg", :id => id, :product_id =>product.to_param.to_s, :nb => (i+1), :class => class_name, :type => 'off'
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
        link_to('Disponible en DVD', product_path(:id => dvd), :id => 'dvd-btn', :class => 'like-btn-NOTYET') if dvd
      else
        ''
      end
    else
      ''
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
          content += "<p id=\"oscars\">#{link_to ("Lire la suite", product_awards_path(:product_id=>product.to_param))}</p>"
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
end
