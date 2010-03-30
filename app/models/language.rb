class Language < ActiveRecord::Base
  establish_connection :dvdpost_main

  set_table_name :products_languages

  set_primary_key :languages_id

  alias_attribute :name, :name

  has_and_belongs_to_many :products, :join_table => :products_to_languages, :foreign_key => :products_languages_id, :association_foreign_key => :products_id

  named_scope :by_language, lambda {|language| {:conditions => {:languagenav_id => DVDPost.product_languages[language]}}}
  named_scope :preferred, :conditions => {:languages_id => [1, 2, 3]}

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
