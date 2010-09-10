class ProductsController < ApplicationController
  before_filter :find_product, :only => [:uninterested, :seen, :awards, :trailer]

  def index
    @filter = current_customer.filter || current_customer.build_filter
    params.delete(:search) if params[:search] == t('products.left_column.search')
    @products = if params[:view_mode] == 'recommended'
      current_customer.recommendations({:page => params[:page]})
    else
      Product.filter(@filter, params)
    end

    if params[:view_mode] == 'recommended'
      @source = DVDPost.source_wishlist[:recommandation]
    else
      @source = DVDPost.source_wishlist[:else]
    end

    @category = Category.find(params[:category_id]) if params[:category_id] && !params[:category_id].empty?
    @countries = ProductCountry.visible.order
  end

  def show
    @filter = current_customer.filter || current_customer.build_filter
    @product = Product.normal_available.find(params[:id])
    @product.views_increment
    @reviews = @product.reviews.approved.by_language.paginate(:page => params[:reviews_page])
    @reviews_count = @product.reviews.approved.by_language.count
    @recommendations = @product.recommendations.paginate(:page => params[:recommendation_page], :per_page => 6)
    if params[:recommendation].to_i == 1
      @source = DVDPost.source_wishlist[:recommandation]
    elsif params[:recommendation].to_i == 2
      @source = DVDPost.source_wishlist[:recommandation_product]
    else
      @source = DVDPost.source_wishlist[:else]
    end
    respond_to do |format|
      format.html do
        @categories = @product.categories
        @already_seen = current_customer.assigned_products.include?(@product)
        begin
          @cinopsis = DVDPost.cinopsis_critics(@product.imdb_id.to_s)
          @cinopsis_error = false
        rescue => e
          @cinopsis_error = true
          logger.error("Failed to retrieve critic of cinopsis: #{e.message}")
        end
        if params[:recommendation]
          DVDPost.send_evidence_recommendations('UserRecClick', @product.to_param, current_customer, request.remote_ip)
        end
        DVDPost.send_evidence_recommendations('ViewItemPage', @product.to_param, current_customer, request.remote_ip)
      end
      validation = validation(@product.imdb_id, request.remote_ip, 'check')
      @token = validation[:token]
      format.js {
        if params[:reviews_page]
          render :partial => 'products/show/reviews', :locals => {:product => @product, :reviews_count => @reviews_count, :reviews => @reviews}
        elsif params[:recommendation_page]
          render :partial => 'products/show/recommendations', :object => @recommendations
        end
      }
    end
  end

  def uninterested
    unless current_customer.rated_products.include?(@product) || current_customer.seen_products.include?(@product)
      @product.uninterested_customers << current_customer
      DVDPost.send_evidence_recommendations('NotInterestedItem', @product.to_param, current_customer, request.remote_ip)
    end
    respond_to do |format|
      format.html {redirect_to product_path(:id => @product.to_param)}
      format.js   {render :partial => 'products/show/seen_uninterested', :locals => {:product => @product}}
    end
  end

  def seen
    @product.seen_customers << current_customer
    respond_to do |format|
      format.html {redirect_to product_path(:id => @product.to_param)}
      format.js   {render :partial => 'products/show/seen_uninterested', :locals => {:product => @product}}
    end
  end

  def awards
    respond_to do |format|
      format.js {render :partial => 'products/show/awards', :locals => {:product => @product, :size => 'full'}}
    end
  end

  def trailer
    respond_to do |format|
      format.js   {render :partial => 'products/trailer', :locals => {:product => @product}}
      format.html {redirect_to @product.trailer.url}
    end
  end

private
  def find_product
    @product = Product.normal_available.find(params[:product_id])
  end
end
