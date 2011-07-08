class CustomerAttribute < ActiveRecord::Base
  has_one :customer, :foreign_key => :customers_id, :primary_key => :customer_id

  named_scope :ordered, :order => 'points desc'
  named_scope :limit, lambda {|limit| {:limit => limit}}
end