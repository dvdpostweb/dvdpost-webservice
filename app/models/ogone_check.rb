class OgoneCheck < ActiveRecord::Base
  set_table_name :ogone_check
  
  belongs_to :customer, :foreign_key => :customers_id
end