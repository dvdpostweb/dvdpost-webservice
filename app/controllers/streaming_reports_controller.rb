class StreamingReportsController < ApplicationController
  def new
    @product = Product.normal_available.find_by_imdb_id(params[:streaming_product_id])
    @message = Message.new
    
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    
  end
end
