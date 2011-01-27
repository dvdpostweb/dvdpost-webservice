class InfoController < ApplicationController

   

  def index
    if params[:page_name] == 'get_connected' || params[:page_name] == 'get_connected_order'
      unless current_customer
        @hide_menu = true
      end
    end
    if params[:page_name] == 'whoweare'
      @locale = false
    else
      @locale = true
    end
  end
end
