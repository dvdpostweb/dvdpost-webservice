class SponsorshipEmail < ActiveRecord::Base
  set_table_name :mem_get_mem
  set_primary_key :mem_get_mem_id

  belongs_to :customer, :foreign_key => :customers_id

  before_save :init_status
  
  def init_status
    self.date = Time.now.to_s(:db)
  end
end
