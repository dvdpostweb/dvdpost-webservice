class WishlistSource < ActiveRecord::Base
  has_many :wishlist_items
end