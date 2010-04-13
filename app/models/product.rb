class Product < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  establish_connection :dvdpost_main

  set_primary_key :products_id

  alias_attribute :created_at,   :products_date_added
  alias_attribute :kind,         :products_type
  alias_attribute :year,         :products_year
  alias_attribute :runtime,      :products_runtime
  alias_attribute :rating,       :products_rating
  alias_attribute :media,        :products_media
  alias_attribute :product_type, :products_product_type
  alias_attribute :availability, :products_availability

  belongs_to :director, :foreign_key => :products_id
  belongs_to :country, :class_name => 'ProductCountry', :foreign_key => :products_countries_id
  belongs_to :picture_format, :foreign_key => :products_picture_format
  has_one :public, :primary_key => :products_public, :foreign_key => :public_id, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_many :descriptions, :class_name => 'ProductDescription', :foreign_key => :products_id
  has_many :trailers, :foreign_key => :products_id
  has_many :wishlist_items
  has_many :reviews, :foreign_key => :products_id
  has_many :ratings, :foreign_key => :products_id
  has_many :uninteresteds, :foreign_key => :products_id
  has_many :uninterested_customers, :through => :uninteresteds, :source => :customer
  has_and_belongs_to_many :actors, :join_table => :products_to_actors, :foreign_key => :products_id, :association_foreign_key => :actors_id
  has_and_belongs_to_many :categories, :join_table => :products_to_categories, :foreign_key => :products_id, :association_foreign_key => :categories_id
  has_and_belongs_to_many :soundtracks, :join_table => :products_to_soundtracks, :foreign_key => :products_id, :association_foreign_key => :products_soundtracks_id
  has_and_belongs_to_many :subtitles, :join_table => :products_to_undertitles, :foreign_key => :products_id, :association_foreign_key => :products_undertitles_id, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_and_belongs_to_many :languages, :join_table => :products_to_languages, :foreign_key => :products_id, :association_foreign_key => :products_languages_id, :conditions => {:languagenav_id => DVDPost.product_languages[I18n.locale.to_s]}

  named_scope :by_kind,     lambda {|kind| {:conditions => {:products_type => DVDPost.product_kinds[kind]}}}
  named_scope :by_media,    lambda {|media| {:conditions => {:products_media => (media.kind_of?(Array) ? media.collect{|m| DVDPost.product_types[m]} : DVDPost.product_types[media])}}}
  named_scope :by_language, lambda {|language| {:conditions => {(language.to_s == 'fr' ? :products_language_fr : :products_undertitle_nl) => 1}}}
  named_scope :by_imdb_id,  lambda {|imdb_id| {:conditions => {:imdb_id => imdb_id}}}
  named_scope :search,      lambda {|search| {:conditions => ['products_title LIKE ?', "%#{search}%"]}}

  def description
    descriptions.by_language(I18n.locale).first
  end

  def title
    description ? description.title : products_title
  end

  def trailer
    localized_trailers = trailers.by_language(I18n.locale.to_s)
    localized_trailers ? localized_trailers.first : nil
  end

  def image
    description && description.image ? File.join(DVDPost.images_path, description.image) : ''
  end

  def get_rating(customers=nil, rating_customer=nil)
    if customers && rating_customer
      rating_customer.value.to_i*2
    else
      rating_count == 0 ? 0 : ((rating_users.to_f/rating_count.to_f)*2).round
    end
  end

  def rating_by_customer(customer=nil)
    ratings.by_customer(customer).first
  end

  def is_new?
    availability > 0 and created_at.between?(3.months.ago, Time.now) and products_next == 0
  end

  def is_dvdpostchoice
    products_dvdpostchoice == 1
  end

  def dvd?
    media == DVDPost.product_types[:dvd]
  end

  def bluray?
    media == DVDPost.product_types[:bluray]
  end

  def series?
    products_series_id != 0
  end

  def available_to_sale?
    quantity_to_sale > 0
  end

  def views_increment
    # Dirty raw sql.
    # This could be fixed with composite_primary_keys but version 2.3.5.1 breaks all other associations.
    connection.execute("UPDATE products_description SET products_viewed = #{description.viewed + 1} WHERE (products_id = #{to_param}) AND (language_id = #{DVDPost.product_languages[I18n.locale]})")
    description.viewed
  end
end
