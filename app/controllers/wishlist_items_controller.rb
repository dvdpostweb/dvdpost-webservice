class WishlistItemsController < ApplicationController
  before_filter :set_body_id

  def index
    @wishlist_items = current_customer.wishlist_items.ordered.include_products
    @transitted_items = current_customer.orders.in_transit(:order => "orders.date_purchased ASC")
  end

  def new
    @wishlist_item = WishlistItem.new
    product = Product.find(params[:product_id])
    @wishlist_item.product_id = product.to_param if product
    render :layout => false
  end

  def create
    begin
      @wishlist_item = WishlistItem.new(params[:wishlist_item])
      @wishlist_item.customer = current_customer
      @wishlist_item.save
      flash[:notice] = "#{@wishlist_item.product.title} has been added to your wishlist with a #{@wishlist_item.priority} priority."
    rescue => e
      flash[:notice] = "This product was not added to your wishlist."
    end
  end

  private
  def set_body_id
    @body_id = 'mywhishlist'
  end
end
