class Order < ActiveRecord::Base
  set_primary_key :orders_id

  alias_attribute :updated_at, :last_modified
  alias_attribute :created_at, :date_purchased

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :status, :class_name => 'OrderStatus', :foreign_key => :orders_status, :conditions => {:language_id => DVDPost.product_languages[I18n.locale]}
  has_one :order_product, :foreign_key => :orders_id
  has_one :product, :through => :order_product, :source => :product
  has_many :status_histories, :class_name => 'OrderStatusHistory', :foreign_key => :orders_id
  has_many :messages, :foreign_key => :orders_id

  named_scope :in_transit, :conditions => {:orders_status => [1, 2]}
  named_scope :in_transit_plus, :conditions => {:orders_status => [1, 2, 12, 17]}
  named_scope :ordered, :order => 'date_purchased DESC'

  def changed_at
    updated_at || created_at
  end

  def product_dvd
    order_product.product_dvd
  end

  def is_new?
    created_at.to_date + 2.days > Time.now.to_date
  end

  def update_status!(new_status)
    status_histories.create(:old_status => status, :new_status => new_status)
    update_attribute(:status, new_status)
  end
end
