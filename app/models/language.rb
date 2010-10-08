class Language < ActiveRecord::Base
  set_table_name :products_languages

  set_primary_key :languages_id

  alias_attribute :name, :languages_description

  has_and_belongs_to_many :products, :join_table => :products_to_languages, :foreign_key => :products_languages_id, :association_foreign_key => :products_id

  named_scope :by_language, lambda {|language| {:conditions => {:languagenav_id => DVDPost.product_languages[language]}}}
  named_scope :preferred, :conditions => {:languages_id => [1, 2, 3, 4, 5, 6, 8]}
  named_scope :not_preferred, :conditions => ["languages_id not in (?)", [1, 2, 3, 4, 5, 6, 8]]
  named_scope :limit, lambda {|limit| {:limit => limit}}
  

  def code
    case id
    when 1
      'fr'
    when 2
      'nl'
    when 3
      'en'
    else
      ''
    end
  end
end
