class ProductsController < ApplicationController
  before_filter :find_product, :only => [:uninterested, :seen, :awards, :trailer]

  def index
    @filter = current_customer.filter || current_customer.build_filter
    params.delete(:search) if params[:search] == t('products.left_column.search')
    
    
    if params[:category_id]
      @popular = current_customer.streaming({:category_id => params[:category_id]}).paginate(:per_page => 6, :page => params[:popular_streaming_page])
    end
    
    
    respond_to do |format|
      format.html do
        @products = if params[:view_mode] == 'recommended'
          if(session[:sort_type] != params[:sort_type] || session[:sort] != params[:sort])
            expiration_recommendation_cache()
          end
          session[:sort_type]=params[:sort_type]
          session[:sort]=params[:sort]
          
          retrieve_recommendations(params[:page], { :sort => params[:sort], :sort_type => params[:sort_type]})
        else
          Product.filter(@filter, params)
        end
        @source = WishlistItem.wishlist_source(params, @wishlist_source)
        @category = Category.find(params[:category_id]) if params[:category_id] && !params[:category_id].empty?
        @countries = ProductCountry.visible.order
        
        @jacket_mode = Product.get_jacket_mode(params)
        if(params[:view_mode] == nil && params[:list_id] == nil && params[:category_id] == nil)
          session[:menu_categories] = true
          session[:menu_tops] = false
        end
        @class_sort = Hash.new
        @next_type_sort = Hash.new
        type = case params[:sort_type]
          when 'asc' then  params[:sort_type]
          when 'desc' then  params[:sort_type]
          else 
            'desc'
          end
        if !params[:sort]
          params[:sort] = 'default'
        end
        DVDPost.sort_by.each do |key, value|
          if params[:sort] == key
            @class_sort[key] = "select select_#{type}"
            @next_type_sort[key] = params[:sort_type] == 'asc' ? 'desc' : 'asc' 
          else
            @class_sort[key] = ""
            @next_type_sort[key] = DVDPost.sort_type_next[key]
          end
        end
      end
      format.js {
        if params[:category_id]
          render :partial => 'products/index/streaming', :locals => {:products => @popular}
        end
      }
    end  
  end

  def show
    @filter = current_customer.filter || current_customer.build_filter
    @product = Product.normal_available.find(params[:id])
    @product.views_increment
    @public_url = "http://www.dvdpost.be/product_info_public.php?products_id=#{@product.to_param}"
    if @product.imdb_id == 0
      @reviews = @product.reviews.approved.by_language(I18n.locale).paginate(:page => params[:reviews_page], :per_page => 3)
      @reviews_count = @product.reviews.approved.by_language(I18n.locale).count
    else  
      @reviews = Review.by_imdb_id(@product.imdb_id).approved.by_language(I18n.locale).find(:all, :joins => :product).paginate(:page => params[:reviews_page], :per_page => 3)
      @reviews_count = Review.by_imdb_id(@product.imdb_id).approved.by_language(I18n.locale).find(:all, :joins => :product).count
    end
    product_recommendations = @product.recommendations
    @recommendations = product_recommendations.paginate(:page => params[:recommendation_page], :per_page => 6) if product_recommendations
    @source = (!params[:recommendation].nil? ? params[:recommendation] : @wishlist_source[:elsewhere])
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
        if params[:recommendation].to_i == @wishlist_source[:recommendation] || params[:recommendation].to_i == @wishlist_source[:recommendation_product]
          Customer.send_evidence('UserRecClick', @product.to_param, current_customer, request.remote_ip)
        end
        Customer.send_evidence('ViewItemPage', @product.to_param, current_customer, request.remote_ip)
      end
      @token = current_customer.get_token(@product.imdb_id)
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
      Customer.send_evidence('NotInterestedItem', @product.to_param, current_customer, request.remote_ip)
    end
    respond_to do |format|
      format.html {redirect_to product_path(:id => @product.to_param)}
      format.js   {render :partial => 'products/show/seen_uninterested', :locals => {:product => @product}}
    end
  end

  def seen
    @product.seen_customers << current_customer
    Customer.send_evidence('AlreadySeen', @product.to_param, current_customer, request.remote_ip)
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
    trailer = @product.trailers.by_language(I18n.locale).paginate(:per_page => 1, :page => params[:trailer_page])
    respond_to do |format|
      format.js   {render :partial => 'products/trailer', :locals => {:trailer => trailer.first, :trailers => trailer}}
      format.html {redirect_to trailer.first.url}
    end
  end

  def menu_tops
    
    type = params[:type] || 'open'
    if type == 'close'
      session[:menu_tops] = false
    else
      session[:menu_tops] = true
      session[:menu_categories] = false
      
    end
   render :nothing => true
  end

  def menu_categories
    type = params[:type] || 'open'
    if type == 'close'
      session[:menu_categories] = false
    else
      session[:menu_categories] = true
      session[:menu_tops] = false
    end
   render :nothing => true
  end

private
  def find_product
    @product = Product.normal_available.find(params[:product_id])
  end
end
