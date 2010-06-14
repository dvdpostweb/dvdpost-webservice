class ProductsController < ApplicationController
  def index
    @products = Product.available.ordered.by_kind(:normal)
    @products = @products.filtered_by_ids(retrieve_recommendations_for_index) if params[:recommended]
    @products = @products.by_category(params[:category_id]) if params[:category_id] && !params[:category_id].empty?
    @products = @products.by_actor(params[:actor_id]) if params[:actor_id] && !params[:actor_id].empty?
    @products = @products.by_director(params[:director_id]) if params[:director_id] && !params[:director_id].empty?
    @products = @products.by_top(params[:top_id]) if params[:top_id] && !params[:top_id].empty?
    @products = @products.by_theme(params[:theme_id]) if params[:theme_id] && !params[:theme_id].empty?
    @products = @products.by_media(params[:media].keys) if params[:media]
    @products = @products.by_public(params[:public_min], params[:year_max]) if params[:public_min] && params[:public_max]
    @products = @products.by_period(params[:year_min], params[:year_max]) if params[:year_min] && params[:year_max]
    @products = @products.by_country(params[:country]) if params[:country] && !params[:country] == 0
    @products = Product.search_clean(params[:search]).sphinx_by_kind(:normal) if params[:search]
    @products = @products.paginate(:page => params[:page])
    
    @countries = ProductCountry.visible
    @selected_country = ProductCountry.find(params[:country]) if params[:country] && !params[:country] == 0
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
