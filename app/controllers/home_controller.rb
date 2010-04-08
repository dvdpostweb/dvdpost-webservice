class HomeController < ApplicationController
  def indicator_closed
    session[:indicator_stored] = true
    render :nothing => true
  end
end
