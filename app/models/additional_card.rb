class AdditionalCard < ActiveRecord::Base
  set_table_name :additional_card

  belongs_to :customer,         :foreign_key => :customers_id
  validates_inclusion_of :number, :in => 0..5

  named_scope :gfc, :conditions => {:campaign => DVDPostConfig[:default_campaign_gfc]}

  before_save :init_status
  
  def init_status
    self.status = 'create'
    self.create_at = Time.now.to_s(:db)
    self.modify_at = Time.now.to_s(:db)
  end
end