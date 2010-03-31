class Public < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :public

  set_primary_key :public_id

  alias_attribute :description, :public_name

  belongs_to :product

  def name
    DVDPost.local_product_publics[to_param.to_i]
  end

  def image
    DVDPost.product_publics_images[name]
  end
end
