class VodWishlist < ActiveRecord::Base
  has_many :products, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
end