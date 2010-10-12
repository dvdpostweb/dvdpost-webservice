class ReconductionsController < ApplicationController
  def edit
    @reconduction_earlier = current_customer.recondutction_ealier?
    group = (current_customer.address.country_id == 21 ? 1 : 2)
    @showing_abo = 3
    @list_abo = ProductAbo.get_list(group)
  end

  def update
    unless current_customer.recondutction_ealier?
      if(params[:customer] != nil && params[:customer][:next_abo_type_id])
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
    