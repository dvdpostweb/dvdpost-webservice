class ProductDvdStatusHistory < ActiveRecord::Base
  set_table_name :products_dvd_status_history
  set_primary_key :status_history_id

  belongs_to :status, :class_name => 'ProductDvdStatus', :foreign_key => :status_id
  belongs_to :old_status, :class_name => 'ProductDvdStatus', :foreign_key => :previous_status_id
  belongs_to :product, :foreign_key => :products_id
end
