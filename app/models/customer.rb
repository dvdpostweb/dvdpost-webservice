class Customer < ActiveRecord::Base
  set_table_name :customers

  set_primary_key :customers_id

  alias_attribute :abo_active,                   :customers_abo
  alias_attribute :last_name,                    :customers_lastname
  alias_attribute :first_name,                   :customers_firstname
  alias_attribute :credits,                      :customers_abo_dvd_credit
  alias_attribute :email,                        :customers_email_address
  alias_attribute :password,                     :customers_password
  alias_attribute :language,                     :customers_language
  alias_attribute :suspension_status,            :customers_abo_suspended
  alias_attribute :dvds_at_home_count,           :customers_abo_dvd_home_norm
  alias_attribute :address_id,                   :customers_default_address_id
  alias_attribute :inviation_points,             :mgm_points
  alias_attribute :credits,                      :customers_abo_dvd_credit
  alias_attribute :normal_count,                 :customers_abo_dvd_norm
  alias_attribute :adult_count,                  :customers_abo_dvd_adult
  alias_attribute :subscription_expiration_date, :customers_abo_validityto
  alias_attribute :newsletter,                   :customers_newsletter
  alias_attribute :newsletter_parnter,           :customers_newsletterpartner
  alias_attribute :phone,                        :customers_telephone
  alias_attribute :birthday,                     :customers_dob
  alias_attribute :gender,                       :customers_gender
  
  validates_length_of :first_name, :minimum => 2
  validates_length_of :last_name, :minimum => 2
  
  validates_format_of :phone, :with => /^(\+)?[0-9 \/.]+$/, :on => :update

  belongs_to :subscription_type, :foreign_key => :customers_abo_type
  belongs_to :address, :foreign_key => :customers_id, :conditions => {:address_book_id => '#{address_id}'} # Nasty hack for composite keys: http://gem-session.com/2010/03/using-dynamic-has_many-conditions-to-save-nested-forms-within-a-scope
  belongs_to :subscription_payment_method, :foreign_key => :customers_abo_payment_method
  has_one :subscription, :foreign_key => :customerid, :conditions => {:action => [1, 6, 8]}, :order => 'date DESC'
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
  has_many :addresses, :foreign_key => :customers_id
  has_many :payment_offline_request, :foreign_key => :customers_id
  
  has_many :subscriptions, :foreign_key => :customerid, :conditions => {:action => [1, 6, 8]}, :order => 'date DESC', :limit => 1
  has_and_belongs_to_many :seen_products, :class_name => 'Product', :join_table => :products_seen, :uniq => true
  has_and_belongs_to_many :roles, :uniq => true

  def self.find_by_email(args)
    self.find_by_customers_email_address(args)
  end

  def not_rated_products
    assigned_products.all(:conditions => ['products.products_id not in (select products_id from products_rating where customers_id = ?)', to_param.to_i])
  end

  def has_rated?(product)
    rated_products.exists?(product)
  end

  def active?
    (abo_active? and suspension_status == 0)
  end

  def suspended?
    suspension_status == 2
  end

  def suspended_notification
    case subscription_payment_method.to_param.to_i
    when DVDPost.payment_methods[:credit_card]
      I18n.t('customer.cc_paymet_alert')
    when DVDPost.payment_methods[:domicilation]
      I18n.t('customer.domiciliation_paymet_alert')
    else
      I18n.t('customer.other_paymet_alert')
    end
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

  def newsletter!(type,value)
    if type == 'newsletter_parnter'
      update_attribute(:newsletter_parnter, value)
    else
      update_attribute(:newsletter, value)
    end
  end

  def rotation_dvd!(type,value)
    if type == 'adult'
      if normal_count > 0
        update_attribute(:adult_count, (adult_count + value))
        update_attribute(:normal_count, (normal_count - value))
      end
    else
      if adult_count > 0
        update_attribute(:normal_count, (normal_count + value))
        update_attribute(:adult_count, (adult_count - value))
      end
    end
  end

  def credit_empty?
    if self.credits == 0 and self.suspension_status == 0 and self.subscription_type.credits > 0 and self.subscription_expiration_date and self.subscription_expiration_date.to_date !=  Time.now.to_date
      true
    else
      false
    end
  end 

  private

  def convert_created_at
    begin
      self.created_at = Date.civil(self.year.to_i, self.month.to_i, self.day.to_i)
    rescue ArgumentError
      false
    end
  end

  def validate_created_at
    errors.add("Created at date", "is invalid.") unless convert_created_at
  end

end
