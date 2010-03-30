class Director < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_primary_key :directors_id

  alias_attribute :name, :directors_name

  has_many :products, :foreign_key => :products_directors_id
end
