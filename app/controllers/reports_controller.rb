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
