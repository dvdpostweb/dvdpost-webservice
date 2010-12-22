class CableOrder < ActiveRecord::Base
  has_one :customer, :foreign_key => :customers_id, :primary_key => :customer_id
end
