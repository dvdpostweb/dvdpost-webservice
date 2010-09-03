class StreamingProductsController < ApplicationController
  def show
    @streaming = StreamingProduct.find_all_by_imdb_id(params[:id])
    @product = Product.find_by_imdb_id(params[:id])
    @token = Token.available.find_by_imdb_id(params[:id])
    if @token && !@token.restriction(request.remote_ip)
      @token = nil
    end
    respond_to do |format|
      format.html do
        render :action => :show
      end
      format.js {
        stream = StreamingProduct.find_by_id(params[:streaming_product_id])
        if !@token
          if current_customer.credits > 0
            Token.transaction do
              @token = Token.create(
                :customer_id => current_customer.to_param,
                :ip          => request.remote_ip,
                :imdb_id     => params[:id]
              )
              credit = current_customer.update_attribute(:credits, (current_customer.credits - 1))
              if credit == false || !@token
               raise ActiveRecord::Rollback
              end
            end
            #to do credit history
          end  
        end   
        render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => stream.filename}, :layout => false
        }
    end
  end

end