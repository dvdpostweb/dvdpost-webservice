class RatingsController < ApplicationController
  def create
    rate = params['rate'].to_i

    @product = Product.find(params['product_id'])
    @product.update_attribute(:rating_count, (@product.rating_count + 1))
    @product.update_attribute(:rating_users, (@product.rating_users + rate))
    @product.save

    rating = Rating.create(:product => @product, 
                           :customer => current_customer,
                           :value => rate,
                           :updated_at => Time.now,
                           :type => @product.kind,
                           :imdb_id => @product.imdb_id)
  end
end