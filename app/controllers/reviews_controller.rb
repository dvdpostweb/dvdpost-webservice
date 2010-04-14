class ReviewsController < ApplicationController
  def new
    @review = Review.new(:products_id => params[:product_id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @product = Product.find(params[:product_id])
    review = @product.reviews.build(params[:review])
    review.customer = current_customer
    review.save
    flash[:notice] = 'Your review has been saved.'
    redirect_to product_path(:id => @product)
  end
end
