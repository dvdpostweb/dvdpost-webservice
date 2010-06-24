class PhoneRequestsController < ApplicationController
  def new
    @phone_request = PhoneRequest.new
  end

  def create
    @phone_request = PhoneRequest.new(params[:phone_request].merge(:customer => current_customer))
    if @phone_request.save
      flash[:notice] = t('messages.index.messages.phone_request_send_successfully')
      redirect_to messages_path
    else
      flash[:error] = t('messages.index.messages.phone_request_not_send_successfully')
      render :action => :new
    end
  end
end