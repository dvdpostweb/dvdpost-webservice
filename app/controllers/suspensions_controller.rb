class SuspensionsController < ApplicationController
  def new
    @already_suspended = current_customer.suspended?
    if @already_suspended
      @expiration_holidays_date = expiration_holdays_date
    else
      if suspension_count_current_year >= 3
        @too_many_suspensions = true
      else
        @too_many_suspensions = false
      end
    end
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    path = php_path(DVDPost.url_suspension);
    if !current_customer.suspended? && suspension_count_current_year < 3
     duration = params[:suspensions][:duration].to_i

      status = DVDPost.send_suspension(current_customer.to_param,duration,path)
      if status == false
        @error = true
      else
        @error = false
      end
      respond_to do |format|
        format.html
        format.js {render :layout => false}
      end
    end
  end

  private
  def expiration_holdays_date
    if suspension = Suspension.holidays.find_all_by_customer_id(current_customer.to_param).last
      suspension.date_end
    end
  end

  def suspension_count_current_year
    Suspension.holidays.last_year.find_all_by_customer_id(current_customer.to_param).count
  end
end
