class ProductList < ActiveRecord::Base
  has_and_belongs_to_many :products, :join_table => :listed_products, :order => 'listed_products.order asc'
end