class WishlistItem < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :wishlist

  set_primary_key :wl_id

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :product_id
end
