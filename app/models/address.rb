class Address < ActiveRecord::Base
  set_table_name :address_book
  set_primary_key :customers_id

  alias_attribute :first_name, :entry_firstname
  alias_attribute :last_name, :entry_lastname
  alias_attribute :street, :entry_street_address
  alias_attribute :postal_code, :entry_postcode
  alias_attribute :city, :entry_city

  validates_length_of :first_name, :minimum => 2, :message => I18n.translate('activerecord.customer.first_name.too_short')
  validates_length_of :last_name, :minimum => 2, :message => I18n.translate('activerecord.customer.last_name.too_short')
  validates_length_of :street, :minimum => 5, :too_short => I18n.translate('activerecord.customer.first_name.too_short')
  validates_length_of :postal_code, :minimum => 4, :message => I18n.translate('activerecord.customer.last_name.too_short')
  validates_length_of :city, :minimum => 4, :message => I18n.translate('activerecord.customer.last_name.too_short')
  
  def name
    "#{first_name} #{last_name}"
  end
end
