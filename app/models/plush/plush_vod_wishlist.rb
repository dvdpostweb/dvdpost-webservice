class PlushVodWishlist < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"
  set_table_name :vod_wishlists
  has_many :plush_tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
end