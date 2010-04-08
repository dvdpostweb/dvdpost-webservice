module ProductsHelper
  def rating_image(rating,rating_customer,type='DVD_NORM')
    images=""
    if(rating_customer)
      name="star-voted"
      class_name=''
    else
      name="star"
      class_name='star'
    end   
    5.times do |i| 
      if(rating>=2)
        images+=image_tag name+'-on.jpg',:id => (i+1),:class=>class_name, :type=>"full" 
      elsif(rating.odd?)
        images+=image_tag name+'-half.jpg',:id => (i+1),:class=>class_name, :type=>"half" 
      else
        images+=image_tag name+'-off.jpg',:id => (i+1),:class=>class_name, :type=>"off" 
      end
      rating-=2
      if(rating<0)
        rating=0
      end
    end 
    images
  end
end
