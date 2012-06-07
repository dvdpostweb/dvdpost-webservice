class Country < ActiveRecord::Base
  set_table_name :country
  set_primary_key :countries_id

  alias_attribute :name, :countries_name
end