class FiltersController < ApplicationController
  def create
    filter = current_customer.filter || current_customer.build_filter
    filter.update_with_defaults(params[:filter])
    if params[:search] == t('products.left_column.search')
      redirect_to products_path(:view_mode => params[:view_mode], :list_id => params[:list_id], :category_id => params[:category_id])
    else
      redirect_to products_path(:search => params[:search])
    end
  end

  def destroy
    current_customer.filter.destroy
    redirect_to :back
  end
end
