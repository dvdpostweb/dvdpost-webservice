class ProductsController < ApplicationController
  def index
    @products = Product.by_kind(:normal)
    @products = @products.search(params[:search]) if params[:search]
    @products = @products.by_media(params[:media].split(',')) if params[:media]
    @products = @products.paginate(:page => params[:page])
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.paginate(:page => params[:reviews_page])
    @reviews_count = @product.reviews.count
  end
end
