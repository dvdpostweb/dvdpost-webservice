class PhoneRequestsController < ApplicationController
  def new
    @phone_request = PhoneRequest.new
  end

  def create
    @phone_request = PhoneRequest.new(params[:message])

    if @phone_request.save
      flash[:notice] = "Phone request sent successfully"
      redirect_to messages_path
    else
      flash[:error] = "Phone request not sent successfully"
      render :action => :new
    end
  end
end