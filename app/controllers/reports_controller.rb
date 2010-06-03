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
    @status = MessageCategory.by_language(I18n.locale).find(1)
    @product_status = ProductDvdStatus.find(params[:status]) # Needs to be secure so that a user can't set a status by changing this attribute


    current_customer.messages.create(:language_id => DVDPost.product_languages[I18n.locale],
                                     :category_id => @status.to_param,
                                     :order => @order,
                                     :product => @order.product,
                                     :admindate => Time.now.to_s(:db),
                                     :adminby => 99,
                                     :adminmessage => MessageAutoReply.by_language(I18n.locale).find(3).content,
                                     :messagesent => 1)

    @order.product_dvd.update_status!(@product_status)

    # "INSERT INTO #{TABLE_COMPENSATION} (customers_id, compensation_date_given, compensation_comment, orders_id, products_id, products_dvdid)
    # VALUES ('#{$customer_id}', #{Time.now.to_s(:db)}, 'dvd illisible auto', '#{$orders_id}', '#{$pid}', '#{$dvdid}')"

    redirect_to wishlist_path
  end
end
