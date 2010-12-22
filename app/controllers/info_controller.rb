class InfoController < ApplicationController

  skip_before_filter :authenticate! 

  def index
    if params[:page_name] == 'get_connected' || params[:page_name] == 'get_connected_order'
      unless current_customer
        @hide_menu = true
      end
    end
  end
end
