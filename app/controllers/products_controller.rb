class ProductsController < ApplicationController
  def index
    @products = Product.available.by_kind(:normal)
    @products = @products.filtered_by_ids(retrieve_recommendations) if params[:recommended] 
    @products = @products.by_category(params[:category_id]) if params[:category_id] && !params[:category_id].empty?
    @products = @products.by_top(params[:top_id]) if params[:top_id] && !params[:top_id].empty?
    @products = @products.by_theme(params[:theme_id]) if params[:theme_id] && !params[:theme_id].empty?
    @products = @products.search(params[:search]) if params[:search]
    @products = @products.by_media(params[:media].keys) if params[:media]
    # @products = @products.by_type(params[:type].split(',')) if params[:type]
    @products = @products.by_public(params[:public_min], params[:year_max]) if params[:public_min] && params[:public_max]
    @products = @products.by_period(params[:year_min], params[:year_max]) if params[:year_min] && params[:year_max]
    @products = @products.by_duration(params[:duration_min], params[:duration_max]) if params[:duration_min] && params[:duration_max]
    @products = @products.by_soundtracks(params[:soundtrack].keys) if params[:soundtrack]
    @products = @products.by_picture_formats(params[:picture_format]) if params[:picture_format] && !params[:picture_format] == 0
    # @products = @products.by_colors(params[:color].keys) if params[:color]
    # @products = @products.by_oscars(params[:oscars].keys) if params[:oscars]
    @products = @products.by_country(params[:country]) if params[:country] && !params[:country] == 0
    @products = @products.paginate(:page => params[:page])
    @soundtracks = Soundtrack.all
    @picture_formats = PictureFormat.by_language(I18n.locale)
    @countries = ProductCountry.visible
    @selected_soundtracks = Soundtrack.by_soundtracks(params[:soundtrack].keys) if params[:soundtrack]
    @selected_picture_format = PictureFormat.by_language(I18n.locale).find(params[:picture_format]) if params[:picture_format] && !params[:picture_format] == 0
    @selected_country = ProductCountry.find(params[:country]) if params[:country] && !params[:country] == 0
  end

  def show
    @product = Product.available.find(params[:id])
    @categories = @product.categories
    @product.views_increment
    @reviews = @product.reviews.approved.paginate(:page => params[:reviews_page])
    @already_seen = current_customer.assigned_products.include?(@product)
    @reviews_count = @product.reviews.approved.count
    @cinopsis = DVDPost.cinopsis_critics(@product.imdb_id.to_s)
    if params[:recommendation] == "1"
      data = DVDPost.send_evidence_recommendations('UserRecClick', @product.to_param, current_customer, request.remote_ip, {})
    end
    data = DVDPost.send_evidence_recommendations('ViewItemPage', @product.to_param, current_customer, request.remote_ip, {})
  end

  def uninterested
    begin
      @product = Product.available.find(params[:product_id])
      @product.uninterested_customers << current_customer
      data = DVDPost.send_evidence_recommendations('NotInterestedItem', @product.to_param, current_customer, request.remote_ip, {})
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

  private
  def retrieve_recommendations
    when_fragment_expired "#{I18n.locale.to_s}/home/recommendations" do
      DVDPost.home_page_recommendations(current_customer)
    end
  end
end
