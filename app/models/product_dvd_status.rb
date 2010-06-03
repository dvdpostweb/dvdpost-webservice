class ProductDvdStatus < ActiveRecord::Base
  set_table_name :products_dvd_status
  set_primary_key :products_dvd_status_id

  alias_attribute :name, :products_dvd_status_name
end
