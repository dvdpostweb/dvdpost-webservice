class OrderStatusHistory < ActiveRecord::Base
  set_table_name :orders_status_history

  set_primary_key :orders_status_history_id

  alias_attribute :created_at, :date_added

  before_create :set_defaults

  belongs_to :order, :foreign_key => :orders_id
  belongs_to :old_status, :class_name => 'OrderStatus', :foreign_key => :old_value, :conditions => {:language_id => DVDPost.product_languages[I18n.locale]}
  belongs_to :new_status, :class_name => 'OrderStatus', :foreign_key => :new_value, :conditions => {:language_id => DVDPost.product_languages[I18n.locale]}

  private
  def set_defaults
    self.created_at = Time.now.to_s(:db)
    self.customer_notified = [2, 3].include?(new_value) ? 1 : 0 # Hardcoded check if new_status has id 2 or 3
  end
end
