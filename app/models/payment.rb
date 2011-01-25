class Payment < ActiveRecord::Base
  set_table_name :payment

  alias_attribute :customer_id,    :customers_id
  
  named_scope :recovery, :conditions => {:payment_status => [13,14,15,16,17,10,11,12,19,20,21,22]}
end
