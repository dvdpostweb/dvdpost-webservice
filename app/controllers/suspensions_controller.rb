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
    if !current_customer.suspended? && suspension_count_current_year < 3
      duration = params[:suspensions][:duration].to_i
      suspension = Suspension.create(
                               :customer_id => current_customer.to_param,
                               :status => 'HOLIDAYS',
                               :date_added => Time.now.to_s(:db),
                               :date_end => duration.days.from_now,
                               :last_modified => Time.now.to_s(:db),
                               :user_modified => 0
                               )
      expiration_date = current_customer.subscription_expiration_date
      current_customer.update_attributes(:suspension_status => 1, :subscription_expiration_date => expiration_date + duration.days)
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