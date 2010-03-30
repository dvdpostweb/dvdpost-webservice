class Director < ActiveRecord::Base
  set_primary_key :directors_id

  alias_attribute :name, :directors_name

  has_many :products, :foreign_key => :products_directors_id
end
