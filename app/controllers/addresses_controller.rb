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
       respond_to do |format|
          format.html do 
            flash[:notice] = t(:address_modify)
            redirect_to customer_path(:id => current_customer.to_param)
          end
          format.js 
        end
      else
        respond_to do |format|
          format.html do 
            render :action => :edit
          end
          format.js do 
            render :action => :edit, :layout => false
          end
        end
      end
  end
end
