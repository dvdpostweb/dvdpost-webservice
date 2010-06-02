class ReportsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    redirect_to wishlist_path
  end
end
