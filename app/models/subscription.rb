class Subscription < ActiveRecord::Base
  set_table_name :abo
  set_primary_key :products_id

  alias_attribute :created_at, :Date
  alias_attribute :customer_id, :customerid

  def self.action
    action = OrderedHash.new
    action.push(:reconduction_ealier, 13)

    action
  end

  named_scope :reconduction_ealier, :conditions => {:action => self.action[:reconduction_ealier]}
  named_scope :recent,  lambda {{:conditions => {:date => 5.days.ago..Time.now}}}  

  belongs_to :type, :class_name => 'SubscriptionType', :foreign_key => :product_id
  
end
