class StreamingProductsController < ApplicationController
  def show
    @streaming = StreamingProduct.find_all_by_imdb_id(params[:id])
    @product = Product.find_by_imdb_id(params[:id])
    @token = Token.validate(@product.imdb_id, request.remote_ip, 'internal')
    respond_to do |format|
      format.html do
        if current_customer.address.belgian?
          render :action => :show
        else
          render :partial => 'streaming_products/no_access', :layout => true
        end  
      end
      format.js do
        if current_customer.address.belgian?
          stream = StreamingProduct.find_by_id(params[:streaming_product_id])
          if !@token
            if current_customer.credits > 0
              Token.transaction do
                @token = Token.create(
                  :customer_id => current_customer.to_param,
                  :imdb_id     => params[:id]
                )
                token_ip = TokenIp.create(
                  :token_id => @token.id,
                  :ip => request.remote_ip
                )
              
                credit = current_customer.update_attribute(:credits, (current_customer.credits - 1))
                if credit == false || !@token || !token_ip
                  raise ActiveRecord::Rollback
                end
              end
            end
            #to do credit history
          end
        
          if @token   
            StreamingViewingHistory.create(:streaming_product_id => params[:streaming_product_id],:token_id => @token.to_param)
            render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => stream.filename}, :layout => false
          else
            render :partial => 'streaming_products/no_player', :locals => {:token => @token, :filename => stream.filename}, :layout => false
          end
        else
          render :partial => 'streaming_products/no_access', :layout => false
        end
      end
    end
  end
end