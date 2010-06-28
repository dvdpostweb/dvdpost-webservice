class PaymentOfflineRequest < ActiveRecord::Base
  set_primary_key :payment_offline_request_id
  set_table_name :payment_offline_request

  named_scope :recovery, :conditions => {:payment_status => [14,15,16,17,18,19,20,21,22]}
end
