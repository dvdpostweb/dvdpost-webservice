class InfoController < ApplicationController

   

  def index
    if params[:page_name] == 'get_connected' || params[:page_name] == 'get_connected_order'
      unless current_customer
        @hide_menu = true
      end
    end
  end
end
