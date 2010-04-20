class Review < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 3

  set_primary_key :reviews_id

  alias_attribute :created_at,    :date_added
  alias_attribute :text,          :reviews_text
  alias_attribute :rating,        :reviews_rating
  alias_attribute :like_count,    :customers_best_rating
  alias_attribute :dislike_count, :customers_bad_rating
  alias_attribute :rating,        :reviews_rating

  before_create :set_created_at
  before_validation :set_defaults

  validates_presence_of :products_id
  validates_presence_of :customers_id
  validates_presence_of :text
  validates_presence_of :customers_name
  validates_inclusion_of :rating, :in => 0..5

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :product_id

  has_many :review_ratings, :foreign_key => :reviews_id

  default_scope :order => 'customers_best_rating DESC, customers_bad_rating ASC, date_added DESC'
  named_scope :approved, :conditions => :reviews_check

  def likeable_count
    like_count + dislike_count
  end

  def likeability
    like_count - dislike_count
  end

  def rating_by_customer(customer=nil)
    review_ratings.by_customer(customer).first
  end

  def set_defaults
    self.customers_name = customer.name
  end

  def set_created_at
    self.created_at = Time.now.to_s(:db)
  end
end
