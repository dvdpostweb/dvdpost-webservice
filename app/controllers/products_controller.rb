class ProductsController < ApplicationController
  def index
    @products = Product.available.by_kind(:normal)
    @products = @products.search(params[:search]) if params[:search]
    @products = @products.by_media(params[:media].keys) if params[:media]
    # @products = @products.by_type(params[:type].split(',')) if params[:type]
    @products = @products.by_public(params[:public_min], params[:year_max]) if params[:public_min] && params[:public_max]
    @products = @products.by_period(params[:year_min], params[:year_max]) if params[:year_min] && params[:year_max]
    @products = @products.by_duration(params[:duration_min], params[:duration_max]) if params[:duration_min] && params[:duration_max]
    @products = @products.by_soundtracks(params[:soundtrack].keys) if params[:soundtrack]
    @products = @products.by_picture_formats(params[:picture_format].keys) if params[:picture_format]
    @products = @products.paginate(:page => params[:page])
    @soundtracks = Soundtrack.all
    @picture_formats = PictureFormat.by_language(I18n.locale)
  end

  def show
    @product = Product.available.find(params[:id])
    @categories = @product.categories
    @product.views_increment
    @reviews = @product.reviews.approved.paginate(:page => params[:reviews_page])
    @already_seen = current_customer.assigned_products.include?(@product)
    @reviews_count = @product.reviews.approved.count
  end

  def uninterested
    begin
      @product = Product.available.find(params[:product_id])
      @product.uninterested_customers << current_customer
      respond_to do |format|
        format.html {redirect_to product_path(:id => @product.to_param)}
        format.js   {render :partial => 'products/show/seen_uninterested', :locals => {:product => @product}}
      end
    end
  end

  def seen
    begin
      @product = Product.available.find(params[:product_id])
      @product.seen_customers << current_customer
      respond_to do |format|
        format.html {redirect_to product_path(:id => @product.to_param)}
        format.js   {render :partial => 'products/show/seen_uninterested', :locals => {:product => @product}}
      end
    end
  end
  
  def awards
    @product = Product.available.find(params[:product_id])
    respond_to do |format|
      format.js {render :partial => 'products/show/awards', :locals => {:product => @product, :size => 'full'}}
    end
  end
end
