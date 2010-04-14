class Customer < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :customers

  set_primary_key :customers_id

  alias_attribute :abo_active,        :customers_abo
  alias_attribute :last_name,         :customers_lastname
  alias_attribute :first_name,        :customers_firstname
  alias_attribute :credits,           :customers_abo_dvd_credit
  alias_attribute :email,             :customers_email_address
  alias_attribute :password,          :customers_password
  alias_attribute :language,          :customers_language
  alias_attribute :suspension_status, :customers_abo_suspended

  has_many :wishlist_items, :foreign_key => :customers_id
  has_many :wishlist_products, :through => :wishlist_items, :source => :product
  has_many :assigned_items, :foreign_key => :customers_id
  has_many :orders, :foreign_key => :customers_id
  has_many :ratings, :foreign_key => :customers_id
  has_many :reviews, :foreign_key => :customers_id
  has_many :uninteresteds, :foreign_key => :customers_id
  has_many :uninterested_products, :through => :uninteresteds, :source => :product
  has_and_belongs_to_many :seen_products, :class_name => 'Product', :join_table => :products_seen

  def self.find_by_email(args)
    self.find_by_customers_email_address(args)
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
    return nil unless customer = find_by_email(email)
    if customer.authenticated?(password)
      User.find_by_email(email) || User.create(:email => email, :password => password, :email_confirmed => 1)
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end
