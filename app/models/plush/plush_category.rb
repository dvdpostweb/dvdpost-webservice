class PlushCategory < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"
  set_table_name :categories
  set_primary_key :categories_id
  has_and_belongs_to_many :products, :join_table => :products_to_categories, :foreign_key => :categories_id, :association_foreign_key => :products_id
end