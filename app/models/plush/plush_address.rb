class PlushAddress < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"
  set_table_name :address_book

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :country, :foreign_key => :entry_country_id
  alias_attribute :first_name, :entry_firstname
  alias_attribute :last_name, :entry_lastname
  alias_attribute :street, :entry_street_address
  alias_attribute :postal_code, :entry_postcode
  alias_attribute :city, :entry_city
  alias_attribute :country_id, :entry_country_id
  alias_attribute :gender, :entry_gender
end