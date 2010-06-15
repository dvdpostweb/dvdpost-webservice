class ReviewsController < ApplicationController
  def new
    @product=Product.find(params[:product_id])
    @review = Review.new(:products_id => params[:product_id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    begin
      @product = Product.available.find(params[:product_id])
      review = @product.reviews.build(params[:review])
      review.customer = current_customer
      review.languages_id = DVDPost.product_languages[I18n.locale]
      review.save
      flash[:notice] = 'Your review has been saved. It will appear once it\'s approved by an admin.'
    rescue Exception => e  
      flash[:notice] = 'There was a problem when trying to save your review.'
    end
    redirect_to product_path(:id => @product)
  end
end
