class ReviewRatingsController < ApplicationController
  def create
    rate = params[:review_rating][:rate].to_i

    @review = Review.find(params[:review_id])
    if rate == 1
      @review.update_attribute(:like_count, (@review.like_count + 1))
    else
      @review.update_attribute(:dislike_count, (@review.dislike_count + 1))
    end

    review_rating = ReviewRating.create(:reviews_id => @review.to_param, 
                           :customers_id => current_customer.to_param,
                           :value => rate)
    respond_to do |format|
       format.js {render :partial => 'products/show/review', :locals => {:review => @review}}
    end
  end
end