class ReviewRating < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :reviews_rating

  alias_attribute :value, :reviews_interesting

  belongs_to :review
  belongs_to :customer, :foreign_key => :customers_id
  
  named_scope :by_customer, lambda {|customer| {:conditions => {:customers_id => customer.to_param}}}
end

  