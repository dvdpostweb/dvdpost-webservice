class AssignedItem < ActiveRecord::Base
  set_table_name :wishlist_assigned

  set_primary_key :wl_assigned_id

  alias_attribute :assigned_at, :date_assigned

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :products_id
end
