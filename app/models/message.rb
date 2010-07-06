class Message < ActiveRecord::Base
  before_create :set_creation_time
  
  cattr_reader :per_page
  @@per_page = 20
  set_table_name :custserv

  set_primary_key :custserv_id

  validates_presence_of :custserv_cat_id, :on => :create
  validates_presence_of :content

  alias_attribute :created_at,  :customer_date
  alias_attribute :updated_at,  :admindate
  alias_attribute :question,    :message
  alias_attribute :response,    :adminmessage
  alias_attribute :category_id, :custserv_cat_id
  alias_attribute :content,     :adminmessage
  alias_attribute :read,        :is_read

  belongs_to :product, :primary_key => :products_id, :foreign_key => :products_id
  belongs_to :order, :primary_key => :orders_id, :foreign_key => :orders_id
  belongs_to :customer, :foreign_key => :customers_id
  has_many :categories, :class_name => 'MessageCategory', :primary_key => :custserv_cat_id, :foreign_key => :custserv_cat_id

  named_scope :ordered, :order => 'custserv_id desc'
  named_scope :not_read, :conditions => {:is_read => false}

  def category
    categories.by_language(I18n.locale).first
  end

  protected
  def set_creation_time
    self.customer_date = Time.now
  end
end
