module HomeHelper
  def link_to_banner_image(type)
    case type 
    when 'quizz'
      link_to image_tag(@quizz.image), "#{php_path}quizz.php"
    when 'contest'
      link_to image_tag(@contest.image), "#{php_path}contest.php"
    when 'shop'
      link_to image_tag(@shop.image), @shop.url
    when 'community'
      case rand(4)
      when 0
        link_to image_tag('banner_blog.gif', :alt => 'blog dvdpost'), "http://insidedvdpost.blogspot.com/"
      when 1
        link_to image_tag('banner_facebook.gif', :alt => 'facebook dvdpost'), "http://www.facebook.com/s.php?q=20460859834&sid=4587e86f26b471cb22ab4b18b3ec5047#/group.php?sid=4587e86f26b471cb22ab4b18b3ec5047&gid=20460859834"
      when 2  
        link_to image_tag('banner_parrainage.gif', :alt => 'parrainage dvdpost'), "#{php_path}member_get_member.php"
      when 3  
        link_to image_tag('banner_twitter.gif', :alt => 'twitter dvdpost'), "http://twitter.com/dvdpost"
      end 
    else
      'other'
    end
  end

  def carousel_path(carousel)
    case carousel.kind
      when 'MOVIE'
        product_path(:id => carousel.reference_id)
      when 'OTHER'
        info_path(:page_name => carousel.name)
      when 'TOP'
        top_products_path(:top_id => carousel.reference_id) 
      when 'THEME'
        theme_products_path(:theme_id => carousel.reference_id)
      when 'DIRECTOR'
        director_products_path(:director_id => carousel.reference_id)
      when 'ACTOR'
        actor_products_path(:actor_id => carousel.reference_id)
      when 'CATEGORY'
        category_products_path(:category_id => carousel.reference_id)
    end
  end

end
