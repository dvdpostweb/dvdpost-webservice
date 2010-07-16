class Contest < ActiveRecord::Base
  set_table_name :contest

  set_primary_key :contest_id

  validates_numericality_of :contest_name_id

  def validate
    errors.add({}, "Make a choice") if self.answer_id.nil? || self.answer_id > 4 || self.answer_id <= 0
  end
end