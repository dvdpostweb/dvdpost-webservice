class WishlistItemsController < ApplicationController
  def index
    @wishlist_items = current_customer.wishlist_items.available.by_kind(:normal).ordered.include_products
    @transit_or_history = params[:transit_or_history] || 'transit'
    if @transit_or_history == 'history'
      @history_items = current_customer.assigned_items
      locals = {:transit_items => nil, :history_items => @history_items}
    else
      @transit_items = current_customer.orders.in_transit_plus.ordered.all(:include => [:product, :status])
      locals = {:transit_items => @transit_items, :history_items => nil}
    end
    respond_to do |format|
      format.html
      format.js   {render :partial => 'wishlist_items/index/transit_history_list', :locals => locals.merge(:wishlist_items_count => @wishlist_items.count)}
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    product = Product.normal.available.find(params[:product_id])
    @wishlist_item = product.wishlist_items.build
    render :layout => false
  end

  def create
    begin
      if params[:add_all_from_series]
        product = Product.normal.available.find(params[:wishlist_item][:product_id])
        Product.normal.available.find_all_by_products_series_id(product.series_id).collect do |product|
          create_wishlist_item(params[:wishlist_item].merge({:product_id => product.to_param}))
        end
        @wishlist_item = current_customer.wishlist_items.by_product(product)
        flash[:notice] = t('wishlist_items.index.product_serie_add', :title => product.title, :priority => DVDPost.wishlist_priorities.invert[params[:wishlist_item][:priority].to_i])
      else
        @wishlist_item = create_wishlist_item(params[:wishlist_item])
        flash[:notice] = t('wishlist_items.index.product_add', :title => @wishlist_item.product.title, :priority => DVDPost.wishlist_priorities.invert[@wishlist_item.priority])
      end
      redirect_back_or @wishlist_item.product
    rescue Exception => e
      if @wishlist_item && @wishlist_item.product
        flash[:notice] = t('wishlist_items.index.product_not_add', :title => product.title)
        redirect_to product
      else
        flash[:notice] = t('wishlist_items.index.product_error_unexpected')
        redirect_to wishlist_path
      end
    end
  end

  def update
    begin
      @wishlist_item = WishlistItem.find(params[:id])
      @wishlist_item.update_attributes(params[:wishlist_item])
      DVDPost.send_evidence_recommendations('UpdateWishlistItem', params[:id], current_customer, request.remote_ip, {:priority => params[:wishlist_item][:priority]})
      respond_to do |format|
        format.js {render :partial => 'wishlist_items/index/priorities', :locals => {:wishlist_item => @wishlist_item}}
      end
    end
  end

  def destroy
    @wishlist_item = WishlistItem.destroy(params[:id])
    DVDPost.send_evidence_recommendations('RemoveFromWishlist', params[:id], current_customer, request.remote_ip)
    respond_to do |format|
      format.html {redirect_back_or  wishlist_path}
      format.js   {render :status => :ok, :layout => false}
    end
  end

  private
  def create_wishlist_item(params)
    wishlist_item = WishlistItem.new(params)
    wishlist_item.customer = current_customer
    wishlist_item.save
    DVDPost.send_evidence_recommendations('AddToWishlist', params[:product_id], current_customer, request.remote_ip, {:priority => params[:priority]})
    wishlist_item
  end

  def redirect_back_or(path)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to path
  end
end
