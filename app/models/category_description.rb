class CategoryDescription < ActiveRecord::Base
  set_table_name :categories_description

  alias_attribute :name, :categories_name

  belongs_to :category

  named_scope :by_language, lambda {|language| {:conditions => {:language_id => DVDPost.product_languages[language]}}}
end
