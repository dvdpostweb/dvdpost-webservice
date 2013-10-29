class PlushSubscription < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"
  set_table_name :abo
  set_primary_key :abo_id

  alias_attribute :created_at, :Date
  alias_attribute :customer_id, :customerid
  alias_attribute :action, :Action
end