class MessagesController < ApplicationController
  def show
    @message = current_customer.messages.find(params[:id])
    @message.update_attribute(:read, true) unless @message.read?
    render :layout => false
  end

  def index
    @messages = current_customer.messages.ordered.all(:include => :product).paginate(:page => params[:page] || 1)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    @message.customers_id = current_customer.to_param
    @message.language_id = DVDPost.product_languages[I18n.locale]
    @message.messagesent = 0
    if @message.save
      if params[:category_id] == DVDPost.message_categorie[:vod]
        
      end
      flash[:notice] = "Message sent successfully"
      
      respond_to do |format|
        format.html { redirect_to messages_path }
        format.js {@error = false}
      end
    else
      flash[:error] = "Message not sent successfully"
      respond_to do |format|
        format.html {render :action => :new}
        format.js {@error = true}
      end
    end
  end

  def faq
    @faqs = Faq.ordered.all
  end

  def destroy
    @message = Message.destroy(params[:id])
    respond_to do |format|
      format.html {redirect_to messages_path}
      format.js   {render :status => :ok, :layout => false}
    end
  end
end
