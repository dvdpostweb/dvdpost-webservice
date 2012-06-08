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
  alias_attribute :dvds_at_home_adult_count,     :customers_abo_dvd_home_adult
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
  alias_attribute :payment_method,               :customers_abo_payment_method
  alias_attribute :abo_type_id,                  :customers_abo_type
  alias_attribute :auto_stop,                    :customers_abo_auto_stop_next_reconduction
  alias_attribute :next_abo_type_id,             :customers_next_abo_type
  alias_attribute :free_upgrade,                 :customers_locked__for_reconduction
  alias_attribute :promo_type,                   :activation_discount_code_type
  alias_attribute :promo_id,                     :activation_discount_code_id
  alias_attribute :nb_recurring,                 :customers_abo_discount_recurring_to_date
  alias_attribute :payment_method,               :customers_abo_payment_method
  alias_attribute :step,                         :customers_registration_step

  has_one :customer_attribute
  has_many :ratings, :foreign_key => :customers_id
  has_many :reviews, :foreign_key => :customers_id
  has_many :tokens
  belongs_to :address, :foreign_key => :customers_id, :primary_key => :customers_id, :conditions => {:address_book_id => '#{address_id}'}
  has_many :actions, :foreign_key => :customerid, :class_name => 'Subscription', :conditions => {:action => 7}
  has_many :wishlist_items, :foreign_key => :customers_id
  has_many :assigned_items, :foreign_key => :customers_id
  has_many :vod_wishlists
  named_scope :by_custmomer, lambda {|id| {:conditions => ["customers_id > ?", id ]}}
  named_scope :limit, lambda {|limit| {:limit => limit}}
end