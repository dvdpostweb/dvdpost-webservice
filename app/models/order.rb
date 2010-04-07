class Order < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_primary_key :orders_id

  alias_attribute :updated_at, :last_modified
  alias_attribute :updated_at, :date_purchased

  belongs_to :customer, :foreign_key => :customers_id
  has_one :order_product, :foreign_key => :orders_id
  has_one :product, :through => :order_product, :source => :product

  named_scope :in_transit, :conditions => {:orders_status => [1,2]}

  def changed_at
    updated_at || created_at
  end
end
