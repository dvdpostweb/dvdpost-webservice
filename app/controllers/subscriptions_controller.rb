class SubscriptionsController < ApplicationController
  def edit
    @list_abo =  current_customer.get_list_abo
    @showing_abo = 10
    @all_style=true
  end

  def update
      if(params[:customer] != nil && params[:customer][:next_abo_type_id] && !params[:customer][:next_abo_type_id].empty?)
        new_abo = ProductAbo.find(params[:customer][:next_abo_type_id])
        action = (current_customer.subscription_type.qty_credit > new_abo.credits ? Subscription.action[:abo_downgrade] : Subscription.action[:abo_upgrade])
        current_customer.update_attribute(:next_abo_type_id, params[:customer][:next_abo_type_id].to_i)
        current_customer.abo_history(action, params[:customer][:next_abo_type_id].to_i)
      end
  end
end