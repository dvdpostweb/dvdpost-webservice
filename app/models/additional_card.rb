class AdditionalCard < ActiveRecord::Base
  set_table_name :additional_card

  belongs_to :customer,         :foreign_key => :customers_id
  validates_inclusion_of :number, :in => 0..5

  before_save :init_status
  
  def init_status
    self.status = 'create'
  end
end