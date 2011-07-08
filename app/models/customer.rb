class Customer < ActiveRecord::Base
  set_table_name :customers

  set_primary_key :customers_id

  alias_attribute :abo_active,                   :customers_abo

  has_one :customer_attribute
end