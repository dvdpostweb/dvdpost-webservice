class AdditionalCardsController < ApplicationController
  def new
    @number = current_customer.additional_card.sum('number')
    @addition_card = AdditionalCard.new
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @addition_card = AdditionalCard.new(params[:additional_card].merge(:customer => current_customer))
    @number = current_customer.additional_card.sum('number')
    if @addition_card.save
      respond_to do |format|
        format.html
        format.js {render :layout => false}
      end
    else
      respond_to do |format|
        format.html {render :action => :new }
        format.js {render :action => :new, :layout => false}
      end
    end
  end
end
