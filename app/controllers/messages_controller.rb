class MessagesController < ApplicationController
  def show
    @message = current_customer.messages.find(params[:id])
    @message.update_attribute(:is_read, true) unless @message.is_read
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
      flash[:notice] = "Message sent successfully"
      redirect_to messages_path
    else
      flash[:error] = "Message not sent successfully"
      render :action => :new
    end
  end

  def faq
    @faqs = Faq.all
  end

  def destroy
    @message = Message.destroy(params[:id])
    respond_to do |format|
      format.html {redirect_to messages_path}
      format.js   {render :status => :ok, :layout => false}
    end
  end
end
