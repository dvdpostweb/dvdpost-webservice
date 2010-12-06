class WishlistItem < ActiveRecord::Base
  set_table_name :wishlist

  set_primary_key :wl_id

  alias_attribute :created_at, :date_added
  alias_attribute :type, :wishlist_type

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :product_id
  belongs_to :wishlist_source

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
  named_scope :current, :conditions => ['products.products_next = ? and products.products_availability != ?', '0', '-1']
  named_scope :future, :conditions => ['products.products_next = ? and products.products_availability != ?', '1', '-1']
  named_scope :not_available, :conditions => ['products.products_availability = ?',  '-1']
  named_scope :include_products, :include => :product
  named_scope :by_product, lambda {|product| {:conditions => {:product_id => product.to_param}}}
  named_scope :limit, lambda {|limit| {:limit => limit}}

  def self.wishlist_source(params, wishlist_source)
    if params[:view_mode] == 'recommended'
      source = wishlist_source[:recommendation]
    elsif params[:view_mode] == 'recent'
      source = wishlist_source[:new]
    elsif params[:view_mode] == 'soon'
      source = wishlist_source[:soon]
    elsif params[:view_mode] == 'cinema'
      source = wishlist_source[:cinema]
    elsif params[:search]
      source = wishlist_source[:search]
    elsif params[:category_id]
      source = wishlist_source[:category]
    elsif params[:actor_id]
      source = wishlist_source[:actor]
    elsif params[:director_id]
      source = wishlist_source[:director]
    elsif params[:list_id] && !params[:list_id].blank?
      list = ProductList.find(params[:list_id]) 
      if list.theme?
        source = wishlist_source[:theme]
      else
        source = wishlist_source[:top]
      end
    else
      source = wishlist_source[:product_index]
    end
    source
  end

  def self.notify_hoptoad(message)
    begin
      HoptoadNotifier.notify(:error_message => "wishlist_items : #{message}")
    rescue => e
      logger.error("wishlist_items : #{message}")
      logger.error(e.backtrace)
    end
  end

  private
  def set_created_at
    self.created_at = Time.now.to_s(:db)
  end

  def set_defaults
    self.type = product.kind
    self.already_rented = customer.assigned_products.include?(product) ? 'YES' : 'NO'
  end
end
