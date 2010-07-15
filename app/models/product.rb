class Product < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20

  set_primary_key :products_id
  
  alias_attribute :availability,    :products_availability
  alias_attribute :available_at,    :products_date_available
  alias_attribute :created_at,      :products_date_added
  alias_attribute :kind,            :products_type
  alias_attribute :media,           :products_media
  alias_attribute :original_title,  :products_title
  alias_attribute :product_type,    :products_product_type
  alias_attribute :rating,          :products_rating
  alias_attribute :runtime,         :products_runtime
  alias_attribute :series_id,       :products_series_id
  alias_attribute :year,            :products_year

  belongs_to :director, :foreign_key => :products_directors_id
  belongs_to :country, :class_name => 'ProductCountry', :foreign_key => :products_countries_id
  belongs_to :picture_format, :foreign_key => :products_picture_format, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_one :public, :primary_key => :products_public, :foreign_key => :public_id, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_many :descriptions, :class_name => 'ProductDescription', :foreign_key => :products_id
  has_many :ratings, :foreign_key => :products_id
  has_many :reviews, :foreign_key => :products_id
  has_many :trailers, :foreign_key => :products_id
  has_many :uninteresteds, :foreign_key => :products_id
  has_many :uninterested_customers, :through => :uninteresteds, :source => :customer, :uniq => true
  has_many :wishlist_items
  has_and_belongs_to_many :actors, :join_table => :products_to_actors, :foreign_key => :products_id, :association_foreign_key => :actors_id
  has_and_belongs_to_many :categories, :join_table => :products_to_categories, :foreign_key => :products_id, :association_foreign_key => :categories_id
  has_and_belongs_to_many :languages, :join_table => 'products_to_languages', :foreign_key => :products_id, :association_foreign_key => :products_languages_id, :conditions => {:languagenav_id => DVDPost.product_languages[I18n.locale.to_s]}
  has_and_belongs_to_many :product_lists, :join_table => :listed_products, :order => 'listed_products.order asc'
  has_and_belongs_to_many :soundtracks, :join_table => :products_to_soundtracks, :foreign_key => :products_id, :association_foreign_key => :products_soundtracks_id
  has_and_belongs_to_many :seen_customers, :class_name => 'Customer', :join_table => :products_seen, :uniq => true
  has_and_belongs_to_many :subtitles, :join_table => 'products_to_undertitles', :foreign_key => :products_id, :association_foreign_key => :products_undertitles_id, :conditions => {:language_id => DVDPost.product_languages[I18n.locale.to_s]}

  named_scope :by_language, lambda { |language| {:order => language.to_s == 'fr' ? 'products_language_fr DESC' : 'products_undertitle_nl DESC'} }
  named_scope :by_imdb_id, lambda { |imdb_id| {:conditions => {:imdb_id => imdb_id}} }
  named_scope :by_media, lambda { |* media| {:conditions => {:products_media => media.flatten.collect { |m| DVDPost.product_types[m] }}} }
  named_scope :available, :conditions => ['products_status != ?', '-1']
  named_scope :normal, :conditions => {:products_type => DVDPost.product_kinds[:normal]}

  define_index do
    indexes products_media
    indexes products_type
    indexes actors.actors_name,                 :as => :actors_name
    indexes director.directors_name,            :as => :director_name
    indexes descriptions.products_description,  :as => :descriptions_text
    indexes descriptions.products_name,         :as => :descriptions_title

    has products_availability,      :as => :availability
    has products_countries_id,      :as => :country_id
    has products_date_available,    :as => :available_at
    has products_dvdpostchoice,     :as => :dvdpost_choice
    has products_id,                :as => :id
    has products_next
    has products_public,            :as => :audience
    has products_status,            :as => :status
    has products_year,              :as => :year
    # has imdb_id
    has in_cinema_now
    has actors(:actors_id),         :as => :actors_id
    has categories(:categories_id), :as => :category_id
    has director(:directors_id),    :as => :director_id
    has product_lists(:id),         :as => :products_list_ids
    has languages(:languages_id),   :as => :language_ids
    has subtitles(:undertitles_id), :as => :subtitle_ids
    has 'CAST((rating_users/rating_count) AS SIGNED)', :type => :integer, :as => :rating

    set_property :enable_star => true
    set_property :min_prefix_len => 3
    set_property :charset_type => 'sbcs'
    set_property :charset_table => "0..9, A..Z->a..z, a..z, U+C0->a, U+C1->a, U+C2->a, U+C3->a, U+C4->a, U+C5->a, U+C6->a, U+C7->c, U+E7->c, U+C8->e, U+C9->e, U+CA->e, U+CB->e, U+CC->i, U+CD->i, U+CE->i, U+CF->i, U+D0->d, U+D1->n, U+D2->o, U+D3->o, U+D4->o, U+D5->o, U+D6->o, U+D8->o, U+D9->u, U+DA->u, U+DB->u, U+DC->u, U+DD->y, U+DE->t, U+DF->s, U+E0->a, U+E1->a, U+E2->a, U+E3->a, U+E4->a, U+E5->a, U+E6->a, U+E7->c, U+E7->c, U+E8->e, U+E9->e, U+EA->e, U+EB->e, U+EC->i, U+ED->i, U+EE->i, U+EF->i, U+F0->d, U+F1->n, U+F2->o, U+F3->o, U+F4->o, U+F5->o, U+F6->o, U+F8->o, U+F9->u, U+FA->u, U+FB->u, U+FC->u, U+FD->y, U+FE->t, U+FF->s,"
    set_property :ignore_chars => "U+AD"
    set_property :field_weights => {:brand_name => 10, :name_fr => 5, :name_nl => 5, :description_fr => 4, :description_nl => 4}
  end

  # There are a lot of commented lines of code in here which are just used for development
  # Once all scopes are transformed to Thinking Sphinx scopes, it will be cleaned up.
  sphinx_scope(:by_actor)            {|actor|            {:with =>       {:actors_id => actor.to_param}}}
  sphinx_scope(:by_audience)         {|min, max|         {:with =>       {:audience => Public.legacy_age_ids(min, max)}}}
  sphinx_scope(:by_category)         {|category|         {:with =>       {:category_id => category.to_param}}}
  sphinx_scope(:by_country)          {|country|          {:with =>       {:country_id => country.to_param}}}
  sphinx_scope(:by_director)         {|director|         {:with =>       {:director_id => director.to_param}}}
  # sphinx_scope(:by_imdb_id)          {|imdb_id|          {:with =>       {:imdb_id => imdb_id}}}
  sphinx_scope(:by_kind)             {|kind|             {:conditions => {:products_type => DVDPost.product_kinds[kind]}}}
  sphinx_scope(:sphinx_by_media)            {|*media|           {:conditions => {:products_media => media.flatten.collect {|m| DVDPost.product_types[m]}}}}
  sphinx_scope(:by_period)           {|min, max|         {:with =>       {:year => min..max}}}
  sphinx_scope(:by_products_list)    {|product_list|     {:with =>       {:products_list_ids => product_list.to_param}}}
  sphinx_scope(:by_ratings)          {|min, max|         {:with =>       {:rating => min..max}}}
  sphinx_scope(:by_recommended_ids)  {|recommended_ids|  {:with =>       {:id => recommended_ids}}}
  sphinx_scope(:with_languages)      {|language_ids|     {:with =>       {:language_ids => language_ids}}}
  sphinx_scope(:with_subtitles)      {|subtitle_ids|     {:with =>       {:subtitle_ids => subtitle_ids}}}
  sphinx_scope(:sphinx_available)           {{:without => {:status => -1}}}
  sphinx_scope(:dvdpost_choice)      {{:with =>    {:dvdpost_choice => 1}}}
  sphinx_scope(:soon)                {{:with => {:in_cinema_now => 0, :products_next => 1, :rating => 3..5}, :order => '@random'}}
  sphinx_scope(:random)              {{:order => '@random'}}
  sphinx_scope(:order)               {|order, sort_mode| {:order => order, :sort_mode => sort_mode}}
  sphinx_scope(:limit)               {|limit| {:limit => limit}}
  sphinx_scope(:recent)              {{:without => {:availability => 0}, :with => {:available_at => 2.months.ago..Time.now, :products_next => 0, :rating => 3..5}}}
  # named_scope :ordered,             :order => 'products.products_id desc'
  # named_scope :ordered_availaible,  :order => 'products_date_available desc'
  # named_scope :list_ordered,        :order => 'listed_products.order asc'
  # named_scope :normal,              :conditions => {:products_type => DVDPost.product_kinds[:normal]}

  def self.sphinx_search_and_filter(search='', params={})
    products = search_clean(search || '').by_kind(:normal).sphinx_available
    products = products.by_recommended_ids(params[:recommended_ids]) if params[:recommended_ids]
    products = products.by_actor(params[:actor_id]) if params[:actor_id] && !params[:actor_id].empty?
    products = products.by_audience(params[:public_min], params[:year_max]) if params[:public_min] && params[:public_max]
    products = products.by_category(params[:category_id]) if params[:category_id] && !params[:category_id].empty?
    products = products.by_country(params[:country]) if params[:country] && !(params[:country].to_i == -1)
    products = products.by_director(params[:director_id]) if params[:director_id] && !params[:director_id].empty?
    products = products.sphinx_by_media(params[:media].keys) if params[:media]  
    products = products.by_ratings(params[:ratings_min], params[:ratings_max]) if params[:ratings_min] && params[:ratings_max]
    products = products.by_period(params[:year_min], params[:year_max]) if params[:year_min] && params[:year_max]
    products = products.by_products_list(params[:top_id]) if params[:top_id] && !params[:top_id].empty?
    products = products.by_products_list(params[:theme_id]) if params[:theme_id] && !params[:theme_id].empty?
    products = products.with_languages(params[:languages].keys) if params[:languages]
    products = products.with_subtitles(params[:subtitles].keys) if params[:subtitles]
    products = products.dvdpost_choice if params[:dvdpost_choice]
    products = products.recent if params[:view_mode] == 'recent'
    products = products.soon if params[:view_mode] == 'soon'
    products = products.order(:id, :desc)
    # products = products.sphinx_order('listed_products.order asc', :asc) if params[:top_id] && !params[:top_id].empty?
    products
  end

  def recommendations
    begin
      # external service call can't be allowed to crash the app
      recommendation_ids = DVDPost.product_linked_recommendations(self)
    rescue => e
      logger.error("Failed to retrieve recommendations: #{e.message}")
    end
    self.class.find_all_by_products_id(recommendation_ids) if recommendation_ids
  end

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
    availability > 0 && created_at < Time.now && available_at && available_at > 3.months.ago && products_next == 0
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
    str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
  end

  def self.notify_hoptoad(ghost)
    begin
      HoptoadNotifier.notify(:error_message => "Ghost record found: #{ghost.inspect}")
    rescue => e
      logger.error("Exception raised wihile notifying ghost record found: #{ghost.inspect}")
      logger.error(e.backtrace)
    end
  end
end
