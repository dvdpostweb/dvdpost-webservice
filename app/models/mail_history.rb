class MailHistory < ActiveRecord::Base
  set_table_name :mail_messages_sent_history
  set_primary_key :mail_messages_sent_history_id
  belongs_to :customer,         :foreign_key => :customers_id
end