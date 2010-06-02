class OrderProduct< ActiveRecord::Base
  set_table_name :orders_products

  set_primary_key :orders_products_id

  belongs_to :order, :foreign_key => :orders_id
  belongs_to :product, :foreign_key => :products_id

  def product_dvd
    ProductDvd.first(:conditions => {:products_id => product.to_param, :products_dvdid => products_dvd})
  end
end
