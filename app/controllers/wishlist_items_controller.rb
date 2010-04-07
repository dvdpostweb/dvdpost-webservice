class WishlistItemsController < ApplicationController
  before_filter :set_body_id

  def index
    @wishlist_items = current_customer.wishlist_items.ordered.include_products
    orders = current_customer.orders
    @assigned_items = orders.find(:all,:conditions=> "orders_status in (1,2) " ).map(&:order_product)
  end

  private
  def set_body_id
    @body_id = 'mywhishlist'
  end
end
