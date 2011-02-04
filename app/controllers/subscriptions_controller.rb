class SubscriptionsController < ApplicationController
  def edit
    @list_abo =  current_customer.get_list_abo
    @showing_abo = 10
    @all_style=true
    abo_max_order = ProductAbo.maximum(:ordered)
    abo_order = current_customer.subscription_type.ordered
    if current_customer.free_upgrade == 0 && abo_max_order != abo_order
      @free_upgrade = abo_order + 1
    else
      @free_upgrade = 0
    end
    
  end

  def update
      if(params[:customer] != nil && params[:customer][:next_abo_type_id] && !params[:customer][:next_abo_type_id].empty?)
        new_abo = Subscription.subscription_change(current_customer, params[:customer][:next_abo_type_id])
        Subscription.freetest(new_abo)
      end
  end
end