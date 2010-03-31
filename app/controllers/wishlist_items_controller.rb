class WishlistItemsController < ApplicationController
  before_filter :set_body_id

  def index
    @wishlist_items = current_customer.wishlist_items.ordered.include_products
    @assigned_items = current_customer.assigned_items
  end

  private
  def set_body_id
    @body_id = 'mywhishlist'
  end
end
