class HomeController < ApplicationController
  def index

    respond_to do |format|
      format.html {
        @body_id = 'one-col'
        @recommendations = Product.find(555,108794,421,104426,54,120399,58,59)
        @top10 = Product.find(55,555,108794,421,104426,54,120399,58,59,67)
        @soon = Product.by_kind(:normal).available.soon
        @new = Product.by_kind(:normal).available.new_products
        @quizz = QuizzName.find_last_by_focus(1)
        rates = current_customer.not_rated_products
        @rate = rates[rand(rates.count)]
        @contest = ContestName.by_language(I18n.locale).last
        shops = Banner.by_language(I18n.locale).by_size(:small).expiration
        @shop = shops[rand(shops.count)]
        @wishlist_count = current_customer.wishlist_items.count
        @transit_items = current_customer.orders.in_transit(:order => "orders.date_purchased ASC")
        retrieve_news
        recommendations_ids = DVDPost.home_page_recommendations(current_customer.to_param)
        @recommendations = Product.find_all_by_products_id(recommendations_ids).paginate(:page => params[:recommendation_page] , :per_page => 8)
      }
      format.js {
        if params[:news_page]
          retrieve_news
          render :partial => '/home/index/news', :locals => {:news_items => @news_items}
        elsif params[:recommendation_page]
          recommendations_ids = DVDPost.home_page_recommendations(current_customer.to_param)
          @recommendations = Product.find_all_by_products_id(recommendations_ids).paginate(:page => params[:recommendation_page] , :per_page => 8)
          render :partial => 'home/index/recommendations', :locals => {:products => @recommendations}
        end
      }
    end
  end

  def indicator_closed
    session[:indicator_stored] = true
    render :nothing => true
  end

  private
  def retrieve_news
    @news_items = DVDPost.home_page_news.paginate(:per_page => 3, :page => params[:news_page] || 1)
  end
end
