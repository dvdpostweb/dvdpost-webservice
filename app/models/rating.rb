class Rating < ActiveRecord::Base
  establish_connection :dvdpost_main
  
  set_table_name :products_rating
  
  set_primary_key :products_rating_id  
  
  alias_attribute :updated_at, :products_rating_date
  alias_attribute :type, :rating_type
  alias_attribute :value, :products_rating
  
  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :products_id
end
