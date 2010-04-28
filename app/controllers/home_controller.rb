class HomeController < ApplicationController
  def index
    @body_id = 'one-col'
    @recommendations = Product.find(555,108794,421,104426,54,120399,58,59)
    @top10 = Product.find(55,555,108794,421,104426,54,120399,58,59,67)
    @soon = Product.by_kind(:normal).available.soon_products
    @new = Product.by_kind(:normal).available.new_products
    @quizz = QuizzName.find_last_by_focus(1)
    rates = current_customer.not_rated_products
    @rate = rates[rand(rates.count)]
    @contest = ContestName.by_language(I18n.locale).last
    shops = Banner.by_language(I18n.locale).by_size(:small).expiration
    @shop = shops[rand(shops.count)]
    @wishlist_count = current_customer.wishlist_items.count
    @transit_items = current_customer.orders.in_transit(:order => "orders.date_purchased ASC")
    feed_url = 'http://syndication.cinenews.be/rss/newsfr.xml'
    
    @news=open(feed_url) do |http|
      response = http.read
      result = RSS::Parser.parse(response, false)
      data = Array.new
      result.items.each_with_index do |item, i|
        data.push(item) if i <3
      end
      data
    end
  end

  def indicator_closed
    session[:indicator_stored] = true
    render :nothing => true
  end
end