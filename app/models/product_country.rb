class ProductCountry < ActiveRecord::Base
  set_table_name :products_countries

  set_primary_key :countries_id

  alias_attribute :name, :countries_name

  belongs_to :product
end
