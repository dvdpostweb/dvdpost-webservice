class TokensController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    @product_in_wishlist = current_customer.wishlist_items.find_by_product_id(params[:product_id])
    render :layout => false
  end
end