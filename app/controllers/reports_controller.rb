class ReportsController < ApplicationController
  def new
    @order = current_user.orders.find(params[:order_id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @order = current_user.orders.find(params[:order_id])
    if DVDPost.product_dvd_statuses.include?(params[:status])
      status = DVDPost.product_dvd_statuses[params[:status]]

      message = MessageAutoReply.by_language(I18n.locale).find(status[:message]).content
      message_category = MessageCategory.by_language(I18n.locale).find(status[:message_category])
      product_status = ProductDvdStatus.find(status[:product_status])

      current_customer.messages.create(:language_id => DVDPost.product_languages[I18n.locale],
                                       :category_id => message_category.to_param,
                                       :order => @order,
                                       :product => @order.product,
                                       :admindate => Time.now.to_s(:db),
                                       :adminby => 99,
                                       :adminmessage => message,
                                       :messagesent => 1)

      @order.product_dvd.update_status!(product_status)

      if status.keys.include?('at_home')
        if status[:at_home]
          current_customer.add_dvd_at_home!
        else
          current_customer.substract_dvd_at_home!
        end
      end

      # if status == :delivered
      #   update orders set orders_status = 2 where orders_id=  $orders_id
      #   insert into ORDERS_STATUS_HISTORY  (orders_id, new_value, old_value, date_added, customer_notified ) values ('" . $orders_id . "', 2, 12, now(), 1)
      #   INSERT INTO  CUSTSERV_DELAYED_FINNALYARRIVED  (custserv_id, customers_id , customer_date , orders_id, products_id , dvd_id) VALUES ('" . $insert_id . "','" . $customer_id . "', now(), '" . $orders_id . "', '" . $pid . "', '" . $dvdid . "' )
      # end

      if status[:compensation]
        current_customer.compensations.create(:compensation_date_given => Time.now.to_s(:db),
                                              :compensation_comment => 'some comment',
                                              :order => @order,
                                              :product => @order.product,
                                              :products_dvdid => @order.product_dvd.to_param)
      end
    end

    redirect_to wishlist_path
  end
end
