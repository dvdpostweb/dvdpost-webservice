class HomeController < ApplicationController
  def index
    @body_id = 'one-col'
  end

  def indicator_closed
    session[:indicator_stored] = true
    render :nothing => true
  end
end
