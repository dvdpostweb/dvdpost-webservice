class HomeController < ApplicationController
  def index
    @body_id = 'one-col'
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

    feed_url = DVDPost.news_url[I18n.locale]
    @news = open(feed_url) do |http|
      response = http.read
      result = RSS::Parser.parse(response, false)
      result.items
    end
 
    recommendations_ids = open('http://partners.thefilter.com/DVDPostService/RecommendationService.ashx?cmd=UserDVDRecommendDVDs&id=206183&number=100&includeAdult=false&verbose=false') do |data|
      ids = Array.new
      data = Hpricot(data).search('//dvds') do |dvd|
        id=dvd.attributes['id']
        ids.push id
      end
      ids
    end
    @recommendations = Product.find_all_by_products_id(recommendations_ids).paginate(:page => params[:recommendation_page] , :per_page => 8)
  end
  
  def indicator_closed
    session[:indicator_stored] = true
    render :nothing => true
  end

  def news
    page = params[:page]

    feed_url = DVDPost.news_url[I18n.locale]
    @news = open(feed_url) do |http|
      response = http.read
      result = RSS::Parser.parse(response, false)
      result.items
    end
    
    render :partial => '/home/index/news', :locals => {:news => @news, :page => page.to_i}
  end
end