class Contest < ActiveRecord::Base
  set_table_name :contest

  set_primary_key :contest_id

  validates_numericality_of :contest_name_id
  validates_numericality_of :answer_id, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 4
end
