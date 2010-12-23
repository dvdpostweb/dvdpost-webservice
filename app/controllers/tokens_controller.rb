class TokensController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    all = Product.find_all_by_imdb_id(params[:imdb_id])
    @product_in_wishlist = current_customer.wishlist_items.find_all_by_product_id(all)
    @streaming_free = StreamingProductsFree.find_by_imdb_id(@product.imdb_id).available
    render :layout => false
  end
end