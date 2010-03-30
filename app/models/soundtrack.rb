class Soundtrack < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :products_soundtracks

  set_primary_key :soundtracks_id

  alias_attribute :name, :soundtracks_description

  has_and_belongs_to_many :products, :join_table => :products_to_soundtracks, :foreign_key => :products_soundtracks_id, :association_foreign_key => :products_id
end
