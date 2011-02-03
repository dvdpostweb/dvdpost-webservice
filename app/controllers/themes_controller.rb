class ThemesController < ApplicationController
  def index
    if params[:page_name] == 'stvalentin'
      case I18n.locale
        when :fr
          list = [65,68,71,74,77,80]
        when :nl
          list = [66,69,72,75,78,81]
        when :en
          list = [67,70,73,76,79,82]
      end
      @count = 5 
      @themes = Array.new
      @titles = Array.new
      @count.times do |i|
        product_list = ProductList.find(list[i])
        @themes[i] = product_list.products
        @titles[i] = product_list.name
      end
      
    end
  end
end
