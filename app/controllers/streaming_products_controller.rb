class StreamingProductsController < ApplicationController
  def show
    @streaming = StreamingProduct.available.find_all_by_imdb_id(params[:id])
    @product = Product.find_by_imdb_id(params[:id])
    
   
    respond_to do |format|
      format.html do
        
       @validation = validation(@product.imdb_id, request.remote_ip, 'check')
       @token = @validation[:token]
       @status = @validation[:status]
       @unavailable_token = current_customer.tokens.unavailable.find_by_imdb_id(params[:id])
       if current_customer.address.belgian? && (session[:country_code] == 'BE' || session[:country_code] == 'RD')
         if !@streaming.blank?
          render :action => :show
         else
           render :partial => 'streaming_products/not_available', :layout => true
         end
        else
          render :partial => 'streaming_products/no_access', :layout => true
        end  
      end
      format.js do
        if current_customer.address.belgian? && (session[:country_code] == 'BE' || session[:country_code] == 'RD') 
          if !current_customer.payment_suspended?
            validation = validation(@product.imdb_id, request.remote_ip,'modify')
            @token = validation[:token]
            status = validation[:status]
            stream = StreamingProduct.find_by_id(params[:streaming_product_id])
            if !@token
              if current_customer.credits > 0
                abo_process = AboProcess.today.last
                if abo_process 
                  customer_abo_process = current_customer.customer_abo_process_stats.find_by_aboProcess_id(abo_process.to_param)
                end
                if !abo_process || customer_abo_process
                  Token.transaction do
                    @token = Token.create(
                      :customer_id => current_customer.to_param,
                      :imdb_id     => params[:id]
                    )
                    token_ip = TokenIp.create(
                      :token_id => @token.id,
                      :ip => request.remote_ip
                    )
                    result_history = current_customer.remove_credit(1,12)
                    credit = current_customer.update_attribute(:credits, (current_customer.credits - 1))

                    if credit == false || @token.id.blank? || token_ip.id.blank? || result_history == false
                      @token = nil
                      error = Token.error["ROLLBACK"]
                      raise ActiveRecord::Rollback
                    end
                  end
                else
                  error = Token.error["ABO_PROCESS"]
                end
              else
                error = Token.error["CREDIT"]
              end
            else
              #token is valid - new ip to generated
              if status == Token.status["IP_TO_GENERATED"]
                token_ip = TokenIp.create(
                  :token_id => @token.id,
                  :ip => request.remote_ip
                )
                if token_ip.id.blank?
                  @token = nil
                  error = Token.error["ROLLBACK"]
                end 
              # token is valid - new ip - ip available 0 => created 2 new ip
              elsif status == Token.status["IP_TO_CREATED"]
                if current_customer.credits > 0
                  if abo_process 
                    customer_abo_process = current_customer.customer_abo_process_stats.find_by_aboProcess_id(abo_process.to_param)
                  end
                  if !abo_process || customer_abo_process
                    Token.transaction do
                      more_ip = @token.update_attributes(:count_ip => (@token.count_ip + 2), :updated_at => Time.now.to_s(:db))
                      result_history = current_customer.remove_credit(1,13)
                      credit = current_customer.update_attribute(:credits, (current_customer.credits - 1))
                      token_ip = TokenIp.create(:token_id => @token.id,:ip => request.remote_ip)
                      if credit == false || more_ip == false || token_ip.id.blank? || result_history == false
                        @token = nil
                        error = Token.error["ROLLBACK"]
                        raise ActiveRecord::Rollback
                    
                      end
                    end
                  else
                    error = Token.error["ABO_PROCESS"]
                    @token = nil
                  end
                else
                  error = Token.error["CREDIT"]
                  @token = nil
                end
              end
            end
          else
            error = Token.error["SUSPENSION"]
          end
          if @token
            if params[:product_id]
              wl = current_customer.wishlist_items.find_by_product_id(params[:product_id])
              if wl
                wl.destroy()
                DVDPost.send_evidence_recommendations('RemoveFromWishlist', params[:product_id], current_customer, request.remote_ip)   
              end
            end
            StreamingViewingHistory.create(:streaming_product_id => params[:streaming_product_id],:token_id => @token.to_param, :quality => params[:quality])
            render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => stream.filename}, :layout => false
          else
            render :partial => 'streaming_products/no_player', :locals => {:token => @token, :error => error}, :layout => false
          end
        else
          render :partial => 'streaming_products/no_access', :layout => false
        end
      end
    end
  end

  def faq
    
  end
end