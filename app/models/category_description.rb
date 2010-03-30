class CategoryDescription < ActiveRecord::Base
  LANGUAGES = {'fr' => 1, 'nl' => 2, 'en' => 3}

  set_table_name :categories_description

  alias_attribute :name, :categories_name

  belongs_to :category

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => LANGUAGES[language]}}}
end
