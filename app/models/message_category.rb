class MessageCategory < ActiveRecord::Base
  set_table_name :custserv_cat
  set_primary_key :custserv_cat_id

  alias_attribute :name, :custserv_cat_name

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}
end
