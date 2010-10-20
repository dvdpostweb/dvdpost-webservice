class Subscription < ActiveRecord::Base
  set_table_name :abo
  set_primary_key :abo_id

  alias_attribute :created_at, :Date
  alias_attribute :customer_id, :customerid
  alias_attribute :action, :Action

  def self.action
    action = OrderedHash.new
    action.push(:reconduction_ealier, 13)
    action.push(:abo_downgrade, 3)
    action.push(:abo_upgrade, 2)

    action
  end

  named_scope :reconduction_ealier, :conditions => {:action => self.action[:reconduction_ealier]}
  named_scope :recent,  lambda {{:conditions => {:date => 5.days.ago..Time.now}}}
  named_scope :reconduction,  {:conditions => {:action => [7, 17]}}

  belongs_to :type, :class_name => 'SubscriptionType', :foreign_key => :product_id
  
end
