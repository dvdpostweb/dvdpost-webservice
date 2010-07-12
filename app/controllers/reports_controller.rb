class ReportsController < ApplicationController
  def new
    @order = current_customer.orders.find(params[:order_id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    if params[:status] == 'envelope'
      render :action => :envelope
    else
      @order = current_customer.orders.find(params[:order_id])
      if DVDPost.product_dvd_statuses.include?(params[:status].to_sym)
        status = DVDPost.product_dvd_statuses[params[:status].to_sym]

        message_content = MessageAutoReply.by_language(I18n.locale).find(status[:message]).content
        message_category = MessageCategory.by_language(I18n.locale).find(status[:message_category])
        product_status = ProductDvdStatus.find(status[:product_status])

        message = current_customer.messages.create(:language_id => DVDPost.product_languages[I18n.locale],
                                                   :category_id => message_category.to_param,
                                                   :order => @order,
                                                   :product => @order.product,
                                                   :admindate => Time.now.to_s(:db),
                                                   :adminby => 99,
                                                   :adminmessage => message_content,
                                                   :messagesent => 1)

        @order.product_dvd.update_status!(product_status)

        if status.keys.include?(:at_home)
          operator = status[:at_home] ? :increment || :decrement
          current_customer.update_dvd_at_home!(operator, product)
        end

        if status.keys.include?(:order_status)
          order_status = OrderStatus.by_language(I18n.locale).find(status[:order_status])
          @order.update_status!(order_status)
        end

        if params[:status] == 'arrived'
          ProductDvdArrived.create(:message => message,
                                   :customer => current_customer,
                                   :order => @order,
                                   :product => @order.product,
                                   :product_dvd_id => @order.product_dvd.to_param)
        end

        if status[:compensation]
          current_customer.compensations.create(:comment => 'some comment',
                                                :order => @order,
                                                :product => @order.product,
                                                :product_dvd_id => @order.product_dvd.to_param)
        end
      end
      redirect_to wishlist_path
    end
  end
end
