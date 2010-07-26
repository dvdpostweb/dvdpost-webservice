class Email < ActiveRecord::Base
  set_table_name :mail_messages
  
  set_primary_key :mail_messages_id

  alias_attribute :body, :messages_html
  alias_attribute :subject, :messages_subject

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}
  
end