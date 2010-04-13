class ReviewRatingsController < ApplicationController
  def create
    rate = params['rate'].to_i

    @review = Review.find(params['review_id'])
    if rate = 1
      @review.update_attribute(:customers_best_rating, (@review.customers_best_rating + 1))
    else
      @review.update_attribute(:customers_bad_rating, (@product.customers_bad_rating + 1))
    end

    review_rating = ReviewRating.create(:reviews_id => @review.id, 
                           :customers_id => current_customer,
                           :value => rate)
  end
end