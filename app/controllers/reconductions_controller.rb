class ReconductionsController < ApplicationController
  def edit
    @reconduction_earlier = current_customer.recondutction_ealier?
    group = (current_customer.nederlands? ? 2 : 1)
    @showing_abo = 3
    @list_abo = ProductAbo.get_list(group)
    if @reconduction_earlier
      flash[:error] = t('reconduction.reconduction_earlier_already')
      redirect_to root_path
    end
  end

  def update
    unless current_customer.recondutction_ealier?
      if(params[:customer] != nil && params[:customer][:next_abo_type_id] && !params[:customer][:next_abo_type_id].empty?)
        new_abo = ProductAbo.find(params[:customer][:next_abo_type_id])
        action = (current_customer.subscription_type.qty_credit > new_abo.credits ? Subscription.action[:abo_downgrade] : Subscription.action[:abo_upgrade])
        current_customer.update_attribute(:next_abo_type_id, params[:customer][:next_abo_type_id].to_i)
        current_customer.abo_history(action, params[:customer][:next_abo_type_id].to_i)
      end
      current_customer.reconduction_now
    end
    flash[:notice] = t('reconduction.reconduction_earlier')
    redirect_to root_path
  end
end
    