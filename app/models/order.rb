class Order < ActiveRecord::Base
  establish_connection :dvdpost_main


  set_primary_key :orders_id

  belongs_to :customer, :foreign_key => :customers_id
  has_one :order_product, :foreign_key => :orders_id
end
