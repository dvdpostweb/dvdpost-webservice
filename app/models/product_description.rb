class ProductDescription < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :products_description

  alias_attribute :text, :products_description
  alias_attribute :url, :products_url
  alias_attribute :image, :products_image_big

  belongs_to :product

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}

  def full_url
    File.join('http://', url)
  end
end
