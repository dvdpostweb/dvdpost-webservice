class RatingsController < ApplicationController
  def create
    @product = Product.available.find(params[:product_id])
    @product.ratings.create(:customer => current_customer, :value => params[:value])
    current_customer.seen_products << @product
    DVDPost.send_evidence_recommendations('Rating', params[:product_id], current_customer, request.remote_ip, {:rating => params[:value]})
    
    respond_to do |format|
      format.html {redirect_to product_path(@product)}
      format.js   {
        case params[:replace]
        when 'homepage'
          not_rated_products = current_customer.not_rated_products
          not_rated_product = not_rated_products[rand(not_rated_products.count)]
          if not_rated_product 
            render :partial => 'home/index/wishlist_rating', :locals => {:product => not_rated_product}
          else
            render :nothing => true
          end
        else
          render :partial => 'products/rating', :locals => {:product => @product, :background => params[':background'], :size => params[:size]}
        end
      }
    end
  end
end
