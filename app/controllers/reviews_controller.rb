class ReviewsController < ApplicationController

  def index
    @reviews = Review.by_customer_id(params[:customer_id]).approved.ordered.find(:all,:joins => :product, :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [0,1]}}).paginate(:page => params[:page], :per_page => 10)
    @customer = Customer.find(params[:customer_id])
    @source = @wishlist_source[:reviews]
  end

  def new
    @product = Product.normal_available.find(params[:product_id])
    @review = Review.new(:products_id => params[:product_id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    begin
      @product = Product.normal_available.find(params[:product_id])
      review = @product.reviews.build(params[:review])
      review.customer = current_customer
      review.languages_id = DVDPost.product_languages[I18n.locale]
      review.save
      flash[:notice] = t('products.show.review.review_save')
    rescue Exception => e  
      flash[:notice] = t('products.show.review.review_not_save')
    end
    redirect_to product_path(:id => @product)
  end
end
