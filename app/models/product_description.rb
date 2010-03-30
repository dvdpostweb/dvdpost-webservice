class ProductDescription < ActiveRecord::Base
  set_table_name :products_description

  alias_attribute :text, :products_description

  belongs_to :product

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}
end
