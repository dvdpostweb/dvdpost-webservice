class ReportsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @statuses = OrderStatus.by_language(I18n.locale)
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @order = Order.find(params[:order_id])
    @status = OrderStatus.find(params[:status])
    @order.update_status!(@status)
    if @order.update_status!(@status)
      flash[:notice] = 'Status saved!'
    else
      flash[:notice] = 'Status NOT saved!'
    end
    redirect_to wishlist_path
  end
end
