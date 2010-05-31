class OrderStatus < ActiveRecord::Base
  set_table_name :orders_status

  set_primary_key :orders_status_id

  alias_attribute :name, :orders_status_name

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}
end
