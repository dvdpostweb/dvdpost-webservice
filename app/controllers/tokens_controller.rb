class TokensController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    render :layout => false
  end
end