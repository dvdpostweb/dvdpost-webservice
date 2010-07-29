class SponsorshipEmail < ActiveRecord::Base
  set_table_name :mem_get_mem
  set_primary_key :mem_get_mem_id

  belongs_to :customer, :foreign_key => :customers_id

  before_save :init_status
  
  validates_presence_of :lastname, :firstname, :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of :email
  validates_exclusion_of :lastname, :in => ["Nom", "Name", "Naam"]
  validates_exclusion_of :firstname, :in => ["Prénom", "Voornaam", "First name"]

  def init_status
    self.date = Time.now.to_s(:db)
  end
end
