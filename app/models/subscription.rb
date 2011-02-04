class Subscription < ActiveRecord::Base
  set_table_name :abo
  set_primary_key :abo_id

  alias_attribute :created_at, :Date
  alias_attribute :customer_id, :customerid
  alias_attribute :action, :Action

  def self.action
    action = OrderedHash.new
    action.push(:reconduction_ealier, 13)
    action.push(:abo_downgrade, 25)
    action.push(:abo_upgrade, 24)

    action
  end

  named_scope :reconduction_ealier, :conditions => {:action => self.action[:reconduction_ealier]}
  named_scope :recent,  lambda {{:conditions => {:date => 5.days.ago..Time.now}}}
  named_scope :reconduction,  {:conditions => {:action => [7, 17]}}

  belongs_to :type, :class_name => 'SubscriptionType', :foreign_key => :product_id

  def self.subscription_change(current_customer, next_abo_type_id)
    new_abo = ProductAbo.find(next_abo_type_id)
    action = (current_customer.subscription_type.qty_credit > new_abo.credits ? Subscription.action[:abo_downgrade] : Subscription.action[:abo_upgrade])
    current_customer.update_attribute(:next_abo_type_id, next_abo_type_id.to_i)
    current_customer.abo_history(action, next_abo_type_id)
    new_abo
  end

  def self.freetest(new_abo)
    diff_order = new_abo.ordered - current_customer.subscription_type.ordered
    if current_customer.free_upgrade == 0 && diff_order == 1
      diff_credit = new_abo.credits - current_customer.subscription_type.credits
      status = current_customer.add_credit(diff_credit, 6)
      if status 
        current_customer.update_attribute(:free_upgrade, 1)
      end
    end
  end

end