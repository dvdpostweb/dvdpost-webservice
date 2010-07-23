class Sponsorship < ActiveRecord::Base
  set_table_name :mem_get_mem_used

  named_scope :free, :conditions => 'points = 0 and expected_points > 0'
  named_scope :stop, :conditions => 'expected_points = 0'
  named_scope :ok, :conditions => 'points > 0 '
  named_scope :ordered, :order => 'date desc'
  named_scope :group_by_son, :group => 'son_id'

  belongs_to :customer, :foreign_key => :son_id
end
