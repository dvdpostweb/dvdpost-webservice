class WishlistItem < ActiveRecord::Base
  set_table_name :wishlist

  set_primary_key :wl_id

  alias_attribute :created_at, :date_added
  alias_attribute :type, :wishlist_type

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :product_id

  before_create :set_created_at
  before_validation :set_defaults

  validates_presence_of :product
  validates_presence_of :customer
  validates_inclusion_of :type, :in => DVDPost.product_kinds.values
  validates_uniqueness_of :product_id, :scope => [:customers_id, :product_id]

  named_scope :ordered, :order => 'priority ASC, products_name asc, imdb_id, products.products_id'
  named_scope :ordered_by_id, :order => 'wl_id desc'
  
  named_scope :by_kind, lambda {|kind| {:conditions => {:wishlist_type => DVDPost.product_kinds[kind]}}}
  named_scope :available, :conditions => ['products_status != ?', '-1']
  named_scope :current, :conditions => ['products.products_next = ?', '0']
  named_scope :future, :conditions => ['products.products_next = ?', '1']
  named_scope :include_products, :include => :product
  named_scope :by_product, lambda {|product| {:conditions => {:product_id => product.to_param}}}
  named_scope :limit, lambda {|limit| {:limit => limit}}

  private
  def set_created_at
    self.created_at = Time.now.to_s(:db)
  end

  def set_defaults
    self.type = product.kind
    self.already_rented = customer.assigned_products.include?(product) ? 'YES' : 'NO'
  end
end
