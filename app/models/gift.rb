class Gift < ActiveRecord::Base
  set_table_name :mem_get_mem_gift
  set_primary_key :mem_get_mem_gift_id

  named_scope :ordered, :order => 'points asc'
  named_scope :status, :conditions => {:status => true}

  belongs_to :product, :primary_key => :products_id, :foreign_key => :products_id
end