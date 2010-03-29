class Actor < ActiveRecord::Base
  set_primary_key 'actors_id'

  alias_attribute :name, :actors_name

  has_and_belongs_to_many :products, :join_table => :products_to_actors, :foreign_key => :actors_id, :association_foreign_key => :products_id
end
