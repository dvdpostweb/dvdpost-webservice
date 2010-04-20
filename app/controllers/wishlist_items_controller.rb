class WishlistItemsController < ApplicationController
  before_filter :set_body_id

  def index
    @wishlist_items = current_customer.wishlist_items.ordered.include_products
    @transit_or_history = params[:transit_or_history] || 'transit'
    if @transit_or_history == 'history'
      @history_items = current_customer.assigned_items
      locals = {:transit_items => nil, :history_items => @history_items}
    else
      @transit_items = current_customer.orders.in_transit(:order => "orders.date_purchased ASC")
      locals = {:transit_items => @transit_items, :history_items => nil}
    end
    respond_to do |format|
      format.html
      format.js   {render :partial => 'wishlist_items/index/transit_history_list', :locals => locals.merge(:wishlist_items_count => @wishlist_items.count)}
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @wishlist_item = WishlistItem.new
    product = Product.available.find(params[:product_id])
    if params[:add_all_serie].to_i == 1
      @serie_id = product.products_series_id
    end
    @wishlist_item.product_id = product.to_param if product
    render :layout => false
  end

  def create
    begin
      if params[:serie_id]
        priority = params[:wishlist_item][:priority]
        all_products = Product.find_all_by_products_series_id(params[:serie_id])
        all_products.each do |product|
          @wishlist_item = add_wishlist_item({:product_id => product.id, :priority => priority})
        end
        flash[:notice] = "#{@wishlist_item.product.title} has been added to your wishlist with a #{DVDPost.wishlist_priorities.invert[@wishlist_item.priority]} priority and the rest of this serie."
      else
        @wishlist_item = add_wishlist_item(params[:wishlist_item])
        flash[:notice] = "#{@wishlist_item.product.title} has been added to your wishlist with a #{DVDPost.wishlist_priorities.invert[@wishlist_item.priority]} priority."
      end
      redirect_back_or @wishlist_item.product
    rescue Exception => e
      if @wishlist && @wishlist.product
        flash[:notice] = "#{@wishlist_item.product.title} could not added to your wishlist."
        redirect_to @wishlist.product
      else
        flash[:notice] = "An unexpected problem happened when trying to add this product to your wishlist."
        redirect_to wishlist_path
      end
    end
  end
  
  def add_wishlist_item(params)
    wishlist_item = WishlistItem.new(params)
    wishlist_item.customer = current_customer
    wishlist_item.save
    wishlist_item
  end

  def update
    begin
      @wishlist_item = WishlistItem.find(params[:id])
      @wishlist_item.update_attributes(params[:wishlist_item])
      respond_to do |format|
        format.js {render :partial => 'wishlist_items/index/priorities', :locals => {:wishlist_item => @wishlist_item}}
      end
    end
  end

  def destroy
    @wishlist_item = WishlistItem.destroy(params[:id])
    flash[:notice] = "#{@wishlist_item.product.title} was removed from your wishlist."
    respond_to do |format|
      format.html {redirect_to wishlist_path}
      format.js   {render :status => :ok, :layout => false}
    end
  end

  private
  def set_body_id
    @body_id = 'mywhishlist'
  end
end
