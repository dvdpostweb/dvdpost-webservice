class Director < ActiveRecord::Base
  set_primary_key :directors_id

  alias_attribute :name, :directors_name

  belongs_to :product
end
