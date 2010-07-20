class FiltersController < ApplicationController
  def create
    filter = current_customer.filter || current_customer.build_filter
    filter.update_attributes(params[:filter])
    redirect_to products_path(:search => params[:search])
  end

  def destroy
    current_customer.filter.destroy
    redirect_to :back
  end
end
