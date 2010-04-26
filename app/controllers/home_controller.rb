class HomeController < ApplicationController
  def index
    @body_id = 'one-col'
    @recommendations = Product.find(555,108794,421,104426,54,120399,58,59)
    @top_10 = Product.find(55,555,108794,421,104426,54,120399,58,59,67)
    @soon = Product.find(555,108794,421)
    @new = Product.find(555,108794,421)
    @quizz = QuizzName.find_last_by_focus(1)
    @rate = Product.find(900)
    @contest = ContestName.by_language(I18n.locale).last
    shops = Banner.by_language(I18n.locale).by_size(:small).expiration
    @shop = shops[rand(shops.count)]
    @wishlist_count = current_customer.wishlist_items.count
    @transit_items = current_customer.orders.in_transit(:order => "orders.date_purchased ASC")
  end

  def indicator_closed
    session[:indicator_stored] = true
    render :nothing => true
  end
end