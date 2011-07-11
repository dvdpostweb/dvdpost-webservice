class Customer < ActiveRecord::Base
  set_table_name :customers

  set_primary_key :customers_id

  alias_attribute :abo_active,                   :customers_abo

  has_one :customer_attribute
  has_many :ratings, :foreign_key => :customers_id
  has_many :reviews, :foreign_key => :customers_id
end