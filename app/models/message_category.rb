class MessageCategory < ActiveRecord::Base
  set_table_name :custserv_cat

  alias_attribute :name, :custserv_cat_name

  belongs_to :custserv

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}

end
