class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html {
        @top10 = ProductList.by_language(DVDPost.product_languages[I18n.locale]).find_by_home_page(true).products.all(:include => [:director, :actors])
        @soon = Product.normal.available.soon
        @new = Product.normal.available.new_products
        @quizz = QuizzName.find_last_by_focus(1)
        not_rated_products = current_customer.not_rated_products
        @offline_request = current_customer.payment_offline_request.recovery
        if @offline_request.count == 0
          if current_customer.credit_empty?
            @renew_subscription = true
          else
            @not_rated_product = not_rated_products[rand(not_rated_products.count)]
          end
        end
        @contest = ContestName.by_language(I18n.locale).by_date.ordered.first
        shops = Banner.by_language(I18n.locale).by_size(:small).expiration
        @shop = shops[rand(shops.count)]
        @wishlist_count = current_customer.wishlist_items.available.by_kind(:normal).include_products.count
        @transit_items = current_customer.orders.in_transit.all(:include => :product, :order => 'orders.date_purchased ASC')
        @news_items = retrieve_news
        @recommendations = retrieve_recommendations
        @carousel = Landing.by_language(I18n.locale).not_expirated.private.order(:asc).limit(5)
        @carousel += Landing.by_language(I18n.locale).expirated.private.order(:desc).limit(5 - @carousel.count) if @carousel.count < 5
      }
      format.js {
        if params[:news_page]
          render :partial => '/home/index/news', :locals => {:news_items => retrieve_news}
        elsif params[:recommendation_page]
          render :partial => 'home/index/recommendations', :locals => {:products => retrieve_recommendations}
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
    fragment_name = "#{I18n.locale.to_s}/home/news"
    news_items = when_fragment_expired fragment_name, 1.hour.from_now do
      begin
        DVDPost.home_page_news
      rescue => e
        logger.error "Homepage news unavailable: #{e.message}"
        expire_fragment_with_meta(fragment_name)
        nil
      end
    end
    news_items.paginate(:per_page => 3, :page => params[:news_page] || 1) if news_item
  end

  def retrieve_recommendations
    current_customer.recommendations.paginate(:per_page => 8, :page => params[:recommendation_page])
  end
end
