class Compensation < ActiveRecord::Base
  set_table_name :compensation
  set_primary_key :compensation_id

  alias_attribute :product_dvd_id, :products_dvdid

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :order, :foreign_key => :orders_id
  belongs_to :product, :foreign_key => :products_id
end
