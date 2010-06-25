class ProductsController < ApplicationController
  def index
    if params[:search]
      @products = Product.search_clean(params[:search]).sphinx_by_kind(:normal)
    else
      @products = Product.filter(params)
    end
    @products = @products.paginate(:page => params[:page])
    
    @category = Category.find(params[:category_id]) if params[:category_id] && !params[:category_id].empty?
    
    @countries = ProductCountry.visible
    @selected_country = ProductCountry.find(params[:country]) if params[:country] && params[:country].to_i != 0
    @filter = params[:media] || (params[:public_min] && params[:public_max]) || (params[:year_min] && params[:year_max]) || (params[:ratings_min] && params[:ratings_max]) || (params[:country] && !(params[:country].to_i == 0)) || params[:languages] || params[:subtitles] || params[:dvdpost_choice]
  end

  def show
    @product = Product.available.find(params[:id])
    @product.views_increment
    @reviews = @product.reviews.approved.by_language.paginate(:page => params[:reviews_page])
    @reviews_count = @product.reviews.approved.by_language.count
    @recommendations = Product.filtered_by_ids(retrieve_recommendations_for_show(@product)).paginate(:page => params[:recommendation_page], :per_page => 6)
    respond_to do |format|
      format.html do
        @categories = @product.categories
        @already_seen = current_customer.assigned_products.include?(@product)
        @cinopsis = DVDPost.cinopsis_critics(@product.imdb_id.to_s)
        if params[:recommendation] == "1"
          DVDPost.send_evidence_recommendations('UserRecClick', @product.to_param, current_customer, request.remote_ip)
        end
        DVDPost.send_evidence_recommendations('ViewItemPage', @product.to_param, current_customer, request.remote_ip)
      end
      format.js {
        if params[:reviews_page]
          render :partial => 'products/show/reviews', :locals => {:product => @product, :reviews_count => @reviews_count, :reviews => @reviews}
        elsif params[:recommendation_page] 
          render :partial => 'products/show/recommendations', :object => @recommendations
        end
      }  
    end
  end

  def recommendations_paginate
    @recommendations = Product.filtered_by_ids(retrieve_recommendations_for_show(@product)).paginate(:page => params[:recommendation_page], :per_page => 6)

    respond_to do |format|
      format.html do
        @product = Product.available.find(params[:id])
        @product.views_increment
        @reviews = @product.reviews.approved.paginate(:page => params[:reviews_page])
        @reviews_count = @product.reviews.approved.count
        @categories = @product.categories
        @already_seen = current_customer.assigned_products.include?(@product)
        @cinopsis = DVDPost.cinopsis_critics(@product.imdb_id.to_s)
        if params[:recommendation] == "1"
          DVDPost.send_evidence_recommendations('UserRecClick', @product.to_param, current_customer, request.remote_ip)
        end
        DVDPost.send_evidence_recommendations('ViewItemPage', @product.to_param, current_customer, request.remote_ip)
        render :action => :show
      end
      format.js {render :partial => 'products/show/recommendations', :object => @recommendations}
    end
  end

  def uninterested
    begin
      @product = Product.available.find(params[:product_id])
      @product.uninterested_customers << current_customer
      DVDPost.send_evidence_recommendations('NotInterestedItem', @product.to_param, current_customer, request.remote_ip)
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
  def retrieve_recommendations_for_index
    when_fragment_expired "#{I18n.locale.to_s}/home/recommendations" do
      DVDPost.home_page_recommendations(current_customer)
    end
  end

  def retrieve_recommendations_for_show(product)
    when_fragment_expired "#{I18n.locale.to_s}/home/recommendations/show" do
      DVDPost.product_linked_recommendations(current_customer, product)
    end
  end
end
