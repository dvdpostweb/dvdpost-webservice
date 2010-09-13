class CreditHistory < ActiveRecord::Base
  set_table_name :credit_history
  
  validates_presence_of :credit
end