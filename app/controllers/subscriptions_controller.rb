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
        new_abo = ProductAbo.find(params[:customer][:next_abo_type_id])
        action = (current_customer.subscription_type.qty_credit > new_abo.credits ? Subscription.action[:abo_downgrade] : Subscription.action[:abo_upgrade])
        current_customer.update_attribute(:next_abo_type_id, params[:customer][:next_abo_type_id].to_i)
        current_customer.abo_history(action, params[:customer][:next_abo_type_id].to_i)
        #***********************
        #*     free upgrade    *
        #***********************
        
        diff_order = new_abo.ordered - current_customer.subscription_type.ordered
        
        if current_customer.free_upgrade == 0 && diff_order == 1
          diff_credit = new_abo.credits - current_customer.subscription_type.credits
          
          status = current_customer.add_credit(diff_credit, 6)
          if status 
            current_customer.update_attribute(:free_upgrade, 1)
          end
        end
        #***********************
      end
  end
end