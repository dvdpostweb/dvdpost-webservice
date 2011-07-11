class CustomerPoint < ActiveRecord::Base
  has_one :customer, :foreign_key => :customers_id, :primary_key => :customer_id

  named_scope :today,  lambda {{:conditions => {:created_on => Time.now.localtime.midnight..(Time.now.localtime.end_of_day)}}}
  named_scope :recent,  lambda {{:conditions => {:created_on => 30.days.ago.localtime.midnight..Time.now.localtime.end_of_day}}}
  named_scope :recent,  lambda {{:conditions => {:created_on => 30.days.ago.localtime.midnight..Time.now.localtime.end_of_day}}}
  named_scope :not_treated,  lambda {{:conditions => {:treated => 0}}} 
  named_scope :ordered, :order => 'points desc'
  named_scope :limit, lambda {|limit| {:limit => limit}}
  
end