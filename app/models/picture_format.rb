class PictureFormat < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :picture_format

  set_primary_key :picture_format_id

  alias_attribute :name, :picture_format_name

  has_many :products, :foreign_key => :products_picture_format
end
