class OrderProduct< ActiveRecord::Base
  establish_connection :dvdpost_main


  set_primary_key :orders_products_id
  set_table_name :orders_products
  belongs_to :order, :foreign_key => :orders_id
  belongs_to :product, :foreign_key => :products_id
end
