class FiltersController < ApplicationController
  def create
    create_or_update
    redirect_to products_path
  end

  def update
    create_or_update
    redirect_to products_path
  end

  def destroy
    current_customer.filter
    redirect_to :back
  end

  private
  def create_or_update
    @filter = current_customer.filter || current_customer.build_filter
    @filter.update_attributes(params[:filter])
  end
end
