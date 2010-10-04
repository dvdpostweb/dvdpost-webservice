class ReconductionsController < ApplicationController
  def edit
    @reconduction_earlier = current_customer.recondutction_ealier?
  end

  def update
    current_customer.reconduction_now
    render :nothing => true
  end
end
    