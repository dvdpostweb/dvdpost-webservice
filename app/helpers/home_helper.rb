module HomeHelper
  def rating_image_small(product, type='DVD_NORM')
    rating=product.get_rating()
    logger.debug rating
    images = ""
    5.times do |i|
      if rating >= 2
        images += image_tag "little-star-on.jpg", :alt=>'star'
      elsif rating.odd?
        images += image_tag "little-star-on.jpg", :alt=>'star'
      else
        images += image_tag "little-star-off.jpg", :alt=>'star'
      end
      rating -= 2
      rating = 0 if rating < 0
    end 
    images
  end
end