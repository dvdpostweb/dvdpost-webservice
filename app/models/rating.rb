class Rating < ActiveRecord::Base
  set_table_name :products_rating

  set_primary_key :products_rating_id

  alias_attribute :updated_at, :products_rating_date
  alias_attribute :type,       :rating_type
  alias_attribute :value,      :products_rating
  alias_attribute :product_id,      :products_id

  named_scope :by_customer, lambda {|customer| {:conditions => {:customers_id => customer.to_param}}}
  named_scope :limit, lambda {|limit| {:limit => limit}}
  named_scope :ordered, :order => 'count_all desc'
  named_scope :group_by_product, :group => 'products_id'
  named_scope :recent,  lambda {{:conditions => {:products_rating_date => 30.days.ago.localtime.midnight..Time.now.localtime.end_of_day}}}
  named_scope :yesterday,  lambda {{:conditions => {:products_rating_date => 1.day.ago.localtime.localtime.midnight..1.day.ago.localtime.end_of_day}}} 
  named_scope :by_imdb_id, lambda {|imdb_id| {:conditions => {:imdb_id => imdb_id}}}
  
  belongs_to :product, :foreign_key => :products_id
  
end