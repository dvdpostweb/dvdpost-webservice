class SubscriptionType < ActiveRecord::Base
  set_table_name :products_abo
  set_primary_key :products_id

  alias_attribute :credits, :qty_credit

  belongs_to :product, :foreign_key => :products_id
end
