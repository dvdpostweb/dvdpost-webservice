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

  belongs_to :customer, :foreign_key => :customers_id

  named_scope :approved, :conditions => :reviews_check
  named_scope :ordered, :order => 'dvdpost_rating desc, date_added desc'
  named_scope :by_language, lambda {|language| {:conditions => {:languages_id => language}}}
  named_scope :limit, lambda {|limit| {:limit => limit}}
  named_scope :yesterday,  lambda {{:conditions => {:last_modified => 1.day.ago.localtime.localtime.midnight..1.day.ago.localtime.end_of_day}}} 
end