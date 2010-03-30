class Product < ActiveRecord::Base
  set_primary_key :products_id

  alias_attribute :kind,    :products_type
  alias_attribute :title,   :products_title
  alias_attribute :year,    :products_year
  alias_attribute :runtime, :products_runtime

  belongs_to :director, :foreign_key => :products_id
  belongs_to :country, :class_name => 'ProductCountry', :foreign_key => :products_countries_id
  belongs_to :picture_format, :foreign_key => :products_picture_format
  has_one :public, :primary_key => :products_public, :foreign_key => :public_id, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_many :descriptions, :class_name => 'ProductDescription', :foreign_key => :products_id
  has_many :trailers, :foreign_key => :products_id
  has_and_belongs_to_many :actors, :join_table => :products_to_actors, :foreign_key => :products_id, :association_foreign_key => :actors_id
  has_and_belongs_to_many :categories, :join_table => :products_to_categories, :foreign_key => :products_id, :association_foreign_key => :categories_id
  has_and_belongs_to_many :soundtracks, :join_table => :products_to_soundtracks, :foreign_key => :products_id, :association_foreign_key => :products_soundtracks_id

  named_scope :limit, lambda {|limit| {:limit => limit}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:products_type => DVDPost.product_kinds[kind]}}}

  def description
    descriptions.by_language(I18n.locale.to_s).first
  end

  def trailer
    trailers.by_language(I18n.locale.to_s).first
  end
end
