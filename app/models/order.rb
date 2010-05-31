class Order < ActiveRecord::Base
  set_primary_key :orders_id

  alias_attribute :updated_at, :last_modified
  alias_attribute :updated_at, :date_purchased

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :status, :class_name => 'OrderStatus', :foreign_key => :orders_status, :conditions => {:language_id => DVDPost.product_languages[I18n.locale]}
  has_one :order_product, :foreign_key => :orders_id
  has_one :product, :through => :order_product, :source => :product
  has_many :status_histories, :class_name => 'OrderStatusHistory', :foreign_key => :orders_id

  named_scope :in_transit, :conditions => {:orders_status => [1,2]}

  def changed_at
    updated_at || created_at
  end

  def update_status!(new_status)
    # To be continued ...
    
    # status_history = OrderStatusHistory.new
    # status_history.old_status = status
    # status_history.new_status = new_status
    # status_history.save
    # update_attribute(:orders_status, status.to_param)
  end
end
