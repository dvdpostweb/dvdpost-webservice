class RatingsController < ApplicationController
  def create
    rate = params[:rate].to_i
    @product = Product.available.find(params[:product_id])
    @product.update_attribute(:rating_count, (@product.rating_count + 1))
    @product.update_attribute(:rating_users, (@product.rating_users + rate))
    @product.ratings.create(:customer => current_customer, :value => rate)
  end
end
