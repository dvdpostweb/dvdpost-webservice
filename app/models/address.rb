class Address < ActiveRecord::Base
  set_table_name :address_book
  set_primary_key :customers_id

  alias_attribute :first_name, :entry_firstname
  alias_attribute :last_name, :entry_lastname
  alias_attribute :street, :entry_street_address
  alias_attribute :postal_code, :entry_postcode
  alias_attribute :city, :entry_city
  alias_attribute :country_id, :entry_country_id

  validates_length_of :first_name, :minimum => 2
  validates_length_of :last_name, :minimum => 2
  validates_length_of :street, :minimum => 5
  validates_length_of :postal_code, :minimum => 4
  validates_length_of :city, :minimum => 1
  
  def belgian?
    country_id == 21
  end

  def name
    "#{first_name} #{last_name}"
  end
end
