class ProductCountry < ActiveRecord::Base
  set_table_name :products_countries

  set_primary_key :countries_id

  alias_attribute :name, :countries_name

  has_many :products, :foreign_key => :products_countries_id

  named_scope :visible, :conditions => {:inprod => 1}
end
