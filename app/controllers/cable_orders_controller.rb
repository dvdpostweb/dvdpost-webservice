class CableOrdersController < ApplicationController
  def create
    if params[:cable] && current_customer && !current_customer.cable_order 
      CableOrder.create(:name => params[:cable], 
                             :customer_id => current_customer.to_param,
                             :sent => 0)
    end
    render :layout => false
  end

  def new
    if current_customer && !current_customer.cable_order
      @visible = true
      @in = params[:in]
      @out = params[:out]
      @image_in = params[:image_in]
      @image_out = params[:image_out]
      @cable = params[:cable]
      
    else
      @visible = false
    end
    respond_to do |format|
      format.html 
      format.js { render :layout => false}
    end
  end
end
