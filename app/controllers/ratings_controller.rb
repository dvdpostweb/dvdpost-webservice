class RatingsController < ApplicationController
  def create
    @product = Product.normal_available.find(params[:product_id])
    @product.ratings.create(:customer => current_customer, :value => params[:value])
    current_customer.seen_products << @product
    Customer.send_evidence('Rating', params[:product_id], current_customer, request.remote_ip, {:rating => params[:value]})
    logger.debug("@@@#{params[:recommendation]}")
    if params[:recommendation] == 1
      logger.debug("reload")
      expiration_recommendation_cache
    end
    respond_to do |format|
      format.html {redirect_to product_path(:id => @product)}
      format.js   {
        case params[:replace]
        when 'homepage'
          not_rated_products = current_customer.not_rated_products
          not_rated_product = not_rated_products[rand(not_rated_products.count)]
          if not_rated_product 
            render :partial => 'home/index/wishlist_rating', :locals => {:product => not_rated_product}
          else
             render :partial => 'home/index/facebook_like'
          end
        when 'wishlist_start_list'
          popular_page = session[:popular_page] || 1
          popular = current_customer.popular.paginate(:page => popular_page, :per_page => 8)
          if popular_page.to_i > 1 && popular.size == 0
            session[:popular_page] = popular_page.to_i - 1
            popular = current_customer.popular.paginate(:page => session[:popular_page], :per_page => 8)
          end
          render :partial => 'wishlist_items/popular', :locals => {:products => popular, :id => :popular_tab}
        else
          render :partial => 'products/rating', :locals => {:product => @product, :background => params[:background], :size => params[:size]}
        end
      }
    end
  end
end
