class AddressesController < ApplicationController

  def edit
    @address = current_customer.address
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  def update
    @address = current_customer.address
    @customer = current_customer

    if @address.update_attributes(params[:address])
      flash[:notice] = t(:address_modify)
      redirect_to customer_path(:id => current_customer.to_param)
    else
      render :action => :edit
    end
  end
end
