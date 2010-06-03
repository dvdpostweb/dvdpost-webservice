class Customer < ActiveRecord::Base
  set_table_name :customers

  set_primary_key :customers_id

  alias_attribute :abo_active,         :customers_abo
  alias_attribute :last_name,          :customers_lastname
  alias_attribute :first_name,         :customers_firstname
  alias_attribute :credits,            :customers_abo_dvd_credit
  alias_attribute :email,              :customers_email_address
  alias_attribute :password,           :customers_password
  alias_attribute :language,           :customers_language
  alias_attribute :suspension_status,  :customers_abo_suspended
  alias_attribute :dvds_at_home_count, :customers_abo_dvd_home_norm

  has_many :wishlist_items, :foreign_key => :customers_id
  has_many :wishlist_products, :through => :wishlist_items, :source => :product
  has_many :assigned_items, :foreign_key => :customers_id
  has_many :assigned_products, :through => :assigned_items, :source => :product
  has_many :orders, :foreign_key => :customers_id
  has_many :ratings, :foreign_key => :customers_id
  has_many :rated_products, :through => :ratings, :source => :product, :uniq => true
  has_many :reviews, :foreign_key => :customers_id
  has_many :uninteresteds, :foreign_key => :customers_id
  has_many :uninterested_products, :through => :uninteresteds, :source => :product, :uniq => true
  has_many :messages, :foreign_key => :customers_id
  has_many :compensations, :foreign_key => :customers_id
  has_and_belongs_to_many :seen_products, :class_name => 'Product', :join_table => :products_seen, :uniq => true
  has_and_belongs_to_many :roles, :uniq => true

  def self.find_by_email(args)
    self.find_by_customers_email_address(args)
  end

  def not_rated_products
    seen_products.all(:conditions => ['products_id not in (select products_id from products_rating where customers_id = ?)', to_param.to_i])
  end

  def has_rated?(product)
    rated_products.exists?(product)
  end

  def active?
    (abo_active? and suspension_status == 0)
  end

  def authenticated?(provided_password)
    hash_password, salt = password.split(':')
    result = Digest::MD5.hexdigest("#{salt}#{provided_password}")
    return hash_password == result
  end

  def self.authenticate(email, password)
    return nil      unless customer = find_by_email(email)
    return customer if     customer.authenticated?(password)
  end

  def has_role?(role)
    roles.include?(role)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def add_dvd_at_home!
    update_attribute(:dvds_at_home_count, (dvds_at_home_count + 1))
  end

  def substract_dvd_at_home!
    update_attribute(:dvds_at_home_count, (dvds_at_home_count - 1))
  end
end
