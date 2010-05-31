class Product < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  set_primary_key :products_id

  alias_attribute :created_at,     :products_date_added
  alias_attribute :kind,           :products_type
  alias_attribute :year,           :products_year
  alias_attribute :runtime,        :products_runtime
  alias_attribute :rating,         :products_rating
  alias_attribute :media,          :products_media
  alias_attribute :product_type,   :products_product_type
  alias_attribute :availability,   :products_availability
  alias_attribute :original_title, :products_title
  alias_attribute :series_id,      :products_series_id

  belongs_to :director, :foreign_key => :products_directors_id
  belongs_to :country, :class_name => 'ProductCountry', :foreign_key => :products_countries_id
  belongs_to :picture_format, :foreign_key => :products_picture_format, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_one :public, :primary_key => :products_public, :foreign_key => :public_id, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_many :descriptions, :class_name => 'ProductDescription', :foreign_key => :products_id
  has_many :trailers, :foreign_key => :products_id
  has_many :wishlist_items
  has_many :reviews, :foreign_key => :products_id
  has_many :ratings, :foreign_key => :products_id
  has_many :uninteresteds, :foreign_key => :products_id
  has_many :uninterested_customers, :through => :uninteresteds, :source => :customer, :uniq => true
  has_and_belongs_to_many :actors, :join_table => :products_to_actors, :foreign_key => :products_id, :association_foreign_key => :actors_id
  has_and_belongs_to_many :categories, :join_table => :products_to_categories, :foreign_key => :products_id, :association_foreign_key => :categories_id
  has_and_belongs_to_many :soundtracks, :join_table => :products_to_soundtracks, :foreign_key => :products_id, :association_foreign_key => :products_soundtracks_id
  has_and_belongs_to_many :subtitles, :join_table => :products_to_undertitles, :foreign_key => :products_id, :association_foreign_key => :products_undertitles_id, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_and_belongs_to_many :languages, :join_table => :products_to_languages, :foreign_key => :products_id, :association_foreign_key => :products_languages_id, :conditions => {:languagenav_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_and_belongs_to_many :seen_customers, :class_name => 'Customer', :join_table => :products_seen, :uniq => true
  has_and_belongs_to_many :product_lists, :join_table => :listed_products, :order => 'listed_products.order asc'

  named_scope :by_kind,             lambda {|kind| {:conditions => {:products_type => DVDPost.product_kinds[kind]}}}
  named_scope :by_category,         lambda {|category| {:include => :categories, :conditions => {:categories => {:categories_id => category.to_param}}}}
  named_scope :by_top,              lambda {|top| {:include => :product_lists, :conditions => {:product_lists => {:id => top.to_param}}}}
  named_scope :by_theme,            lambda {|theme| {:include => :product_lists, :conditions => {:product_lists => {:id => theme.to_param}}}}
  named_scope :by_media,            lambda {|*media| {:conditions => {:products_media => media.flatten.collect{|m| DVDPost.product_types[m]}}}}
  named_scope :by_year,             lambda {|year| {:conditions => {:products_year => year}}}
  named_scope :by_period,           lambda {|min, max| {:conditions => {:products_year => min..max}}}
  named_scope :by_country,          lambda {|country| {:include => :country, :conditions => {:products_countries => {:countries_id => country.to_param}}}}
  named_scope :by_language,         lambda {|language| {:order => language.to_s == 'fr' ? 'products_language_fr DESC' : 'products_undertitle_nl DESC'}}
  named_scope :by_imdb_id,          lambda {|imdb_id| {:conditions => {:imdb_id => imdb_id}}}
  named_scope :available,           :conditions => ['products_status != ?', '-1']
  named_scope :by_public,           lambda {|min, max|
    ages = max.to_i == 0 ? (DVDPost.product_publics[:all] if min.to_i == 0) : DVDPost.product_publics.keys.collect {|age| DVDPost.product_publics[age] if age != :all && age.to_i.between?(min.to_i,max.to_i)}.compact
    {:conditions => {:products_public => ages}}
  }
  named_scope :new_products,        :conditions => ['products_availability > 0 and products_next = 0 and products_date_added < now() and products_date_added < DATE_SUB(now(), INTERVAL 3 MONTH) and (rating_users/rating_count)>=3'], :limit => 3, :order => 'rand()'
  named_scope :soon,                :conditions => ['in_cinema_now = 0 and products_next = 1 and (rating_users/rating_count)>=3'], :limit => 3, :order => 'rand()'
  named_scope :filtered_by_ids,     lambda {|*ids| {:conditions => {:products_id => ids.flatten}}}

  define_index do
    indexes products_type
    indexes actors.actors_name,      :as => :actors_names
    indexes director.directors_name, :as => :director_name

    indexes descriptions.products_description,  :as => :descriptions_text
    indexes descriptions.products_name,         :as => :descriptions_title

    set_property :enable_star => true
    set_property :min_prefix_len => 3
    set_property :charset_type => 'sbcs'
    set_property :charset_table => "0..9, A..Z->a..z, a..z, U+C0->a, U+C1->a, U+C2->a, U+C3->a, U+C4->a, U+C5->a, U+C6->a, U+C7->c, U+E7->c, U+C8->e, U+C9->e, U+CA->e, U+CB->e, U+CC->i, U+CD->i, U+CE->i, U+CF->i, U+D0->d, U+D1->n, U+D2->o, U+D3->o, U+D4->o, U+D5->o, U+D6->o, U+D8->o, U+D9->u, U+DA->u, U+DB->u, U+DC->u, U+DD->y, U+DE->t, U+DF->s, U+E0->a, U+E1->a, U+E2->a, U+E3->a, U+E4->a, U+E5->a, U+E6->a, U+E7->c, U+E7->c, U+E8->e, U+E9->e, U+EA->e, U+EB->e, U+EC->i, U+ED->i, U+EE->i, U+EF->i, U+F0->d, U+F1->n, U+F2->o, U+F3->o, U+F4->o, U+F5->o, U+F6->o, U+F8->o, U+F9->u, U+FA->u, U+FB->u, U+FC->u, U+FD->y, U+FE->t, U+FF->s,"
    set_property :ignore_chars => "U+AD"
    set_property :field_weights => {:brand_name => 10, :name_fr => 5, :name_nl => 5, :description_fr => 4, :description_nl => 4}
  end

  # Doesn't work
  #sphinx_scope(:sphinx_available) {'products_status != -1'}

  sphinx_scope(:sphinx_by_kind) {|kind| {:conditions => {:products_type => DVDPost.product_kinds[kind]}}}

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
    File.join(DVDPost.images_path, description.image) if description && !description.image.blank?
  end

  def rating(customer=nil)
    if customer && customer.has_rated?(self)
      ratings.by_customer(customer).first.value.to_i * 2
    else
      rating_count == 0 ? 0 : ((rating_users.to_f / rating_count) * 2).round
    end
  end

  def rate!(value)
    update_attributes({:rating_count => (rating_count + 1), :rating_users => (rating_users + value)})
  end

  def is_new?
    availability > 0 and created_at.between?(3.months.ago, Time.now) and products_next == 0
  end

  def dvdposts_choice?
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

  def self.search_clean(query_string)
    qs = []
    query_string.split.each do |word|
      qs << "*#{replace_specials(word)}*".gsub(/[-_]/, ' ')
    end
    query_string = qs.join(' ')
    
    self.search(query_string, :per_page => 1000)
  end

  def self.replace_specials(str)
#    specials = {'ˆ' => 'a', '‡' => 'a', '‰' => 'a', '‹' => 'a', 'Š' => 'a', '' => 'c', '' => 'e','Ž' => 'e','' => 'e', '‘' => 'e', '“' => 'i','’' => 'i','”' => 'i','•' => 'i', '–' => 'n', '˜' => 'o','—' => 'o','™' => 'o', '›' => 'o','š' => 'o', '' => 'u','œ' => 'u','ž' => 'u','Ÿ' => 'u', '?' => 'y','Ø' => 'y', 'Ë' => 'A', 'ç' => 'A','å' => 'A','Ì' => 'A','€' => 'A', '‚' => 'C', 'é' => 'E','ƒ' => 'E','æ' => 'E','è' => 'E', 'í' => 'I','ê' => 'I','ë' => 'I','ì' => 'I', '„' => 'N', 'ñ' => 'O','î' => 'O','ï' => 'O','Í' => 'O', '…' => 'O', 'ô' => 'U','ò' => 'U','ó' => 'U','†' => 'U', '?' => 'Y'}

#    specials.each do |special, regular|
#      str.gsub!(special, regular)
#    end
    str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s
  end
end
