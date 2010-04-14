class Review < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 3

  establish_connection :dvdpost_main

  set_primary_key :reviews_id

  alias_attribute :created_at, :date_added
  alias_attribute :text, :reviews_text
  alias_attribute :rating, :reviews_rating
  alias_attribute :like_count, :customers_best_rating
  alias_attribute :dislike_count, :customers_bad_rating

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :product_id
  
  has_many :review_ratings, :foreign_key => :reviews_id

  default_scope :order => 'customers_best_rating ASC, customers_bad_rating DESC'

  def likeable_count
    like_count + dislike_count
  end

  def likeability
    like_count - dislike_count
  end
  
  def rating_by_customer(customer=nil)
    review_ratings.by_customer(customer).first
  end
end
