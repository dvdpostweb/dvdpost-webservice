class RatingsController < ApplicationController
  def create
    @product = Product.available.find(params[:product_id])
    @product.ratings.create(:customer => current_customer, :value => params[:value])
    respond_to do |format|
      format.html {redirect_to product_path(@product)}
      format.js   {render :partial => 'products/rating', :locals => {:product => @product, :background => params[:background].to_sym}}
    end
  end
end
