class PlushProduct < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"
  set_table_name :products
  set_primary_key :products_id

  has_and_belongs_to_many :plush_categories, :join_table => :products_to_categories, :foreign_key => :products_id, :association_foreign_key => :categories_id
end