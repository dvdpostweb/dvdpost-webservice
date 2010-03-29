class Description < ActiveRecord::Base
  set_table_name "products_description"
  LANGUAGES = {'fr' => 1, 'nl' => 2, 'en' => 3}

  belongs_to :product

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => LANGUAGES[language]}}}
end
