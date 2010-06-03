class ProductDvdArrived < ActiveRecord::Base
  set_table_name :custserv_delayed_finallyarrived
  set_primary_key :custserv_delayed_finallyarrived_id

  alias_attribute :product_dvd_id, :dvd_id
  alias_attribute :created_at, :customer_date

  before_create :set_created_at

  belongs_to :message, :foreign_key => :custserv_id
  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :order, :foreign_key => :orders_id
  belongs_to :product, :foreign_key => :products_id

  private
  def set_created_at
    self.created_at = Time.now.to_s(:db)
  end
end
