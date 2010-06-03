class MessageAutoReply < ActiveRecord::Base
  set_table_name :custserv_auto_answer
  set_primary_key :custserv_auto_answer_id

  alias_attribute :content, :messages_html

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}
end
