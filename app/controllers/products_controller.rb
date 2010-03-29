class ProductsController < ApplicationController
  def index
    @products = Product.by_kind('dvd').limit(10)
  end

  def show
    @product = Product.find(params[:id])
  end
end
