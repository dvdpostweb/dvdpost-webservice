class ProductAbo < ActiveRecord::Base
  set_table_name :products_abo
  set_primary_key :products_id
  
  alias_attribute :credits,    :qty_credit

  has_one :product, :foreign_key => :products_id
  
  named_scope :available, lambda {|group| {:conditions => ['allowed_public_group = ? or allowed_private_group = ?', group, group]}}
  named_scope :ordered, :order => "qty_credit ASC"
  
  def self.get_list(group = 1)
    available(group).ordered
  end
end