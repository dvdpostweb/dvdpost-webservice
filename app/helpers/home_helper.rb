module HomeHelper
  def rating_image_small(product, type='DVD_NORM',background='white')
    rating = product.get_rating
    images = ""
    if background == :white
      color = ''
    else
      color = 'black-'
    end
    5.times do |i|
      if rating >= 2
        images += image_tag "#{color}little-star-on.jpg", :alt=>'star'
      elsif rating.odd?
        images += image_tag "#{color}little-star-half.jpg", :alt=>'star'
      else
        images += image_tag "#{color}little-star-off.jpg", :alt=>'star'
      end
      rating -= 2
      rating = 0 if rating < 0
    end 
    images
  end

  def link_to_banner_image(type)
    case type 
    when 'quizz'
      link_to image_tag(@quizz.image), 'http://www.dvdpost.be/quizz.php'
    when 'contest'
      link_to image_tag(@contest.image), 'http://www.dvdpost.be/contest.php'
    when 'shop'
      link_to image_tag(@shop.image), @shop.url
    when 'community'
      i=rand(4)
      case i
      when 0
        link_to image_tag('banner_blog.gif',:alt=>'blog dvdpost'), "http://insidedvdpost.blogspot.com/"
      when 1
        link_to image_tag('banner_facebook.gif',:alt=>'facebook dvdpost'), "http://www.facebook.com/s.php?q=20460859834&sid=4587e86f26b471cb22ab4b18b3ec5047#/group.php?sid=4587e86f26b471cb22ab4b18b3ec5047&gid=20460859834"
      when 2  
        link_to image_tag('banner_parrainage.gif',:alt=>'parrainage dvdpost'), "http://www.dvdpost.be/member_get_member.php"
      when 3  
        link_to image_tag('banner_twitter.gif',:alt=>'twitter dvdpost'), "http://twitter.com/dvdpost"
      end 
    else
      'other'
    end
  end

  def carousel_path(carousel)
     case carousel.kind
      when 'MOVIE'
        path = product_path(:id => carousel.reference_id)
      when 'OTHER'
        path = 'test.php' #to do information dispobible into (dvdpost.common.translations2) key => LANDINGS_URL_+id
      when 'TOP'
        path = top_products_path(:top_id => carousel.reference_id) 
      when 'THEME'
        path = theme_products_path(:theme_id => carousel.reference_id)
    end
    path
  end

  def carousel_name_link(carousel)
     case carousel.kind 
      when 'MOVIE'
        'Louer'
      when 'OTHER'
        'GO' #to do information dispobible into (dvdpost.common.translations2) key => LANDINGS_TITLE_+id
      when 'TOP'
        'Voir la selection' #to do
      when 'THEME'
        'Voir la selection' #to do
    end
  end

end