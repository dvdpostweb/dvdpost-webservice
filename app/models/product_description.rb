class ProductDescription < ActiveRecord::Base
  LANGUAGES = {'fr' => 1, 'nl' => 2, 'en' => 3}

  set_table_name :products_description

  alias_attribute :text, :products_description

  belongs_to :product

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => LANGUAGES[language]}}}
end
