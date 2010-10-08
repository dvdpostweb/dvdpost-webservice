class StreamingProductsController < ApplicationController
  def show
    @streaming = StreamingProduct.available.find_all_by_imdb_id(params[:id])
    @product = Product.find_by_imdb_id(params[:id])
    
   
    respond_to do |format|
      format.html do
       @token = current_customer.get_token(@product.imdb_id)
       @token_valid = @token.nil? ? false : @token.validate?(request.remote_ip)
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
            @token = current_customer.get_token(@product.imdb_id)
            status = @token.nil? ? nil : @token.current_status(request.remote_ip)
            streaming_version = StreamingProduct.find_by_id(params[:streaming_product_id])
            if !@token || status == Token.status[:expired]
              creation = current_customer.create_token(params[:id], @product, request.remote_ip)
              @token = creation[:token]
              error = creation[:error]
              
              if @token
                mail_object = Email.by_language(I18n.locale).find(DVDPost.email[:streaming_product])
                recipient = current_customer.email
                product_id = @product.id
                mail_history= MailHistory.create(:date => Time.now().to_s(:db), :customers_id => current_customer.to_param, :mail_messages_id => DVDPost.email[:streaming_product], :language_id => DVDPost.customer_languages[I18n.locale], :customers_email_address=> current_customer.email)
                options = 
                {
                  "\\$\\$\\$customers_name\\$\\$\\$" => "#{current_customer.first_name.capitalize} #{current_customer.last_name.capitalize}",
                  "\\$\\$\\$product_title\\$\\$\\$" => @product.title,
                  "\\$\\$\\$product_image\\$\\$\\$" => @product.image,
                  "\\$\\$\\$streaming_link\\$\\$\\$" => "http://#{request.host}#{products_path(:view_mode => :streaming)}",
                  "\\$\\$\\$product_streaming_link\\$\\$\\$" => "http://#{request.host}#{streaming_product_path(:id => @product.imdb_id)}",
                  "\\$\\$\\$mail_messages_sent_history_id\\$\\$\\$" => mail_history.to_param,
                }
                list = ""
                options.each {|k, v|  list << "#{k.to_s.tr("\\","")}:::#{v};;;"}
                mail_history.update_attributes(:lstvariable => list)
                email_data_replace(mail_object.subject, options)
                subject = email_data_replace(mail_object.subject, options)
                message = email_data_replace(mail_object.body, options)
                Emailer.deliver_send(recipient, subject, message)
                
              end
               
            else
              #token is valid bur new ip to generate
              if status == Token.status[:ip_valid]
                result_token_ip = current_customer.create_token_ip(@token,request.remote_ip)
                if result_token_ip != true
                  @token = nil
                  error = result_token_ip
                end
              # token is valid - new ip - ip available 0 => created 2 new ip
              elsif status == Token.status[:ip_invalid]
                creation = current_customer.create_more_ip(@token, request.remote_ip)
                @token = creation[:token]
                error = creation[:error]
              end
            end
          else
            error = Token.error[:user_suspended]
          end
          if @token
            current_customer.remove_product_from_wishlist(params[:id], request.remote_ip)
            StreamingViewingHistory.create(:streaming_product_id => params[:streaming_product_id],:token_id => @token.to_param, :quality => params[:quality])
            filename =  streaming_version.filename.sub(/\.mp4/,"_#{params[:quality]}.mp4")
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