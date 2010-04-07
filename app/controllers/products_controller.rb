class ProductsController < ApplicationController
  def index
    @products = Product.by_kind(:normal).limit(10)
    @products = @products.search(params[:search]) if params[:search]
    @products = @products.by_media(params[:media].split(',')) if params[:media]
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.paginate :page => params[:reviews_page]
  end
end
