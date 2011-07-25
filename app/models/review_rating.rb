class ReviewRating < ActiveRecord::Base
  set_table_name :reviews_rating
  set_primary_key :reviews_id

  alias_attribute :value, :reviews_interesting
  alias_attribute :customer_id, :customers_id

  belongs_to :review, :foreign_key => :reviews_id
  belongs_to :customer, :foreign_key => :customers_id
  has_and_belongs_to_many :products, :join_table => :reviews, :foreign_key => :reviews_id, :association_foreign_key => :products_id
  named_scope :yesterday,  lambda {{:conditions => {:created_at => 1.day.ago.localtime.localtime.midnight..1.day.ago.localtime.end_of_day}}} 
  named_scope :by_customer, lambda {|customer| {:conditions => {:customers_id => customer.to_param}}}
end
