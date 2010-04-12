class WishlistItem < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :wishlist

  set_primary_key :wl_id

  alias_attribute :priority, :priority_before_type_cast

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :product_id

  named_scope :ordered, :order => 'priority ASC'
  named_scope :movies,  :joins => :product, :conditions => {:products => {:products_product_type => 'Movie',:products_next => 0}}
  named_scope :futur_movies,  :joins => :product, :conditions => {:products => {:products_product_type => 'Movie',:products_next => 1}}
  named_scope :games,   :joins => :product, :conditions => {:products => {:products_product_type => 'Game'}}
  named_scope :include_products, :include => :product
end
