class Compensation < ActiveRecord::Base
  set_table_name :compensation
  set_primary_key :compensation_id

  alias_attribute :created_at, :compensation_date_given
  alias_attribute :comment, :compensation_comment
  alias_attribute :product_dvd_id, :products_dvdid

  before_create :set_created_at

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :order, :foreign_key => :orders_id
  belongs_to :product, :foreign_key => :products_id

  private
  def set_created_at
    self.created_at = Time.now.to_s(:db)
  end
end
