class CustomersController < ApplicationController
  def show
    @customer = current_customer
    @streaming_available = current_customer.get_all_tokens
    
  end

  def edit
    @customer = current_customer
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def update
    @customer = current_customer
    params[:customer][:birthday] = "#{params[:date][:year]}-#{params[:date][:month]}-#{params[:date][:day]}"
    if @customer.update_attributes(params[:customer])
      respond_to do |format|
        format.html do
          flash[:notice] = t(:customer_modify)
          redirect_to customer_path
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

  def newsletter
    @customer = current_customer
    @customer.newsletter!(params[:type], params[:value])
    if params[:type] == 'newsletter'
      data = @customer.newsletter
    else
      data = @customer.newsletter_parnter
    end
    respond_to do |format|
      format.html do
        render :action => :show
      end
      format.js {render :partial => 'customers/show/active', :locals => {:active => data, :type => params[:type]}}
    end
  end

  def rotation_dvd
    @customer = Customer.find(current_customer)
    @customer.rotation_dvd!(params[:type],params[:value].to_i)
    respond_to do |format|
      format.html do
        render :action => :show
      end
      format.js {render :partial => 'customers/show/rotation', :locals => {:customer => @customer}}
    end
  end
end
