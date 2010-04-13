class ReviewRating < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :reviews_rating

  alias_attribute :value, :reviews_interesting

  belongs_to :review
end

  