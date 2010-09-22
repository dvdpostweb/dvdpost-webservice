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
       if streaming_access?
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
        if streaming_access? 
          if !current_customer.payment_suspended?
            validation_result = validation(@product.imdb_id, request.remote_ip,'modify')
            @token = validation_result[:token]
            status = validation_result[:status]
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
                    result_credit = current_customer.remove_credit(1,12)

                    if @token.id.blank? || token_ip.id.blank? || result_credit == false
                      @token = nil
                      error = Token.error["ROLLBACK"]
                      raise ActiveRecord::Rollback
                    else
                      mail = Email.by_language(I18n.locale).find(DVDPost.email[:streaming_product])
                      recipient = current_customer.email
                      product_id = @product.id
                      options = 
                      {
                        "\\{\\{customers_name\\}\\}" => "#{current_customer.first_name.capitalize} #{current_customer.last_name.capitalize}",
                        "\\{\\{product_title\\}\\}" => @product.title,
                        "\\{\\{product_image\\}\\}" => @product.image,
                        "\\{\\{streaming_link\\}\\}" => "http://#{request.host}#{products_path(:view_mode => :streaming)}",
                        "\\{\\{product_streaming_link\\}\\}" => "http://#{request.host}#{streaming_product_path(:id => @product.imdb_id)}",
                      }
                      email_data_replace(mail.subject, options)
                      subject = email_data_replace(mail.subject, options)
                      message = email_data_replace(mail.body, options)
                      Emailer.deliver_send(recipient, subject, message)
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
                      token_ip = TokenIp.create(:token_id => @token.id,:ip => request.remote_ip)
                      if more_ip == false || token_ip.id.blank? || result_history == false
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
            all = Product.find_all_by_imdb_id(params[:id])
            wl = current_customer.wishlist_items.find_all_by_product_id(all)
            unless wl.blank?
              wl.each do |item|
                item.destroy()
                DVDPost.send_evidence_recommendations('RemoveFromWishlist', item.to_param, current_customer, request.remote_ip)   
                
              end
            end
            StreamingViewingHistory.create(:streaming_product_id => params[:streaming_product_id],:token_id => @token.to_param, :quality => params[:quality])
            filename =  stream.filename.sub(/\.mp4/,"_#{params[:quality]}.mp4")
            render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => filename}, :layout => false
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