class Subscription < ActiveRecord::Base
  set_table_name :abo
  set_primary_key :products_id

  alias_attribute :created_at, :Date

  belongs_to :type, :class_name => 'SubscriptionType', :foreign_key => :product_id
end
