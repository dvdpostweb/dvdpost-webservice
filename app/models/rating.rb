class Rating < ActiveRecord::Base
  set_table_name :products_rating

  set_primary_key :products_rating_id

  alias_attribute :updated_at, :products_rating_date
  alias_attribute :type,       :rating_type
  alias_attribute :value,      :products_rating

  before_save :set_defaults
  after_save :set_already_seen

  validates_presence_of :product
  validates_presence_of :customer
  validates_inclusion_of :value, :in => 0..5

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :products_id

  named_scope :by_customer, lambda {|customer| {:conditions => {:customers_id => customer.to_param}}}

  private
  def set_defaults
    self.updated_at = Time.now.to_s(:db)
    self.type = product.kind
    self.imdb_id = product.imdb_id
  end

  def set_already_seen
    product.seen_customers << customer
  end
end
