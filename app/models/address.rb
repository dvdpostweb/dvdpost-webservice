class Address < ActiveRecord::Base
  set_table_name :address_book
  set_primary_keys :customers_id, :address_book_id

  alias_attribute :first_name, :entry_firstname
  alias_attribute :last_name, :entry_lastname
  alias_attribute :street, :entry_street_address
  alias_attribute :postal_code, :entry_postcode
  alias_attribute :city, :entry_city

  def name
    "#{first_name} #{last_name}"
  end
end
