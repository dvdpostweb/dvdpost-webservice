class CustomersController < ApplicationController
  def show
    @customer = current_customer
  end
  
  def newsletter
    @customer = Customer.find(current_customer)
    @customer.newsletter!(params[:type],params[:value])
    respond_to do |format|
      format.html do
         render :action => :show
      end
      format.js {render :partial => 'customers/show/active', :locals => {:active => @customer.newsletter, :type => params[:type]}}
    end        
  end
  def rotation_dvd
    @customer = Customer.find(current_customer)
    @customer.rotation_dvd!(params[:type],params[:value].to_i)
    respond_to do |format|
      format.html do
         render :action => :show
      end
      format.js { render :partial => 'customers/show/rotation', :locals => {:customer => @customer}}
    end        
  end
end
