class ProductsDvdStateHistory < ActiveRecord::Base
  set_table_name :products_dvd_state_history

  before_create :set_status_date

  belongs_to :product, :foreign_key => :products_id

  private
  def set_status_date
    self.date_added = Time.now.to_s(:db)
    self.last_modified = Time.now.to_s(:db)
  end
end