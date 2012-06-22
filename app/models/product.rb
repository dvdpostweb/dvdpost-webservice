class Product < ActiveRecord::Base
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
  alias_attribute :price,           :products_price
  alias_attribute :next,            :products_next
  alias_attribute :studio,          :products_studio

  named_scope :available, :conditions => ["products_status != -1 and products_type != ?", 'abo']
  named_scope :gt_id, lambda {|id| {:conditions => ["products_id >= ?", id]}}
  
  named_scope :limit, lambda {|limit| {:limit => limit}}
  named_scope :ordered, :order => 'products_id asc'
  named_scope :normal_available, :conditions => ['products_status != :status AND products_type = :kind', {:status => '-1', :kind => :dvd_norm}]

  has_and_belongs_to_many :categories, :join_table => :products_to_categories, :foreign_key => :products_id, :association_foreign_key => :categories_id
  has_and_belongs_to_many :actors, :join_table => :products_to_actors, :foreign_key => :products_id, :association_foreign_key => :actors_id
  has_many :recommendations
  
  def self.all_recommendations(id = 0)
    product = Product.available
    if id > 0
      product = product.gt_id(id)
    end
    product.ordered.each do |p|
      p.recommendations.destroy_all
      p.find_recommendations
    end
    nil
  end

  def find_recommendations
    
    cat_ids = categories.collect(&:categories_id).join(', ')
    cat_count = categories.count
    if cat_count >= 4
      min_cat = cat_count-2
    else
      min_cat = cat_count
    end
    rank="0"
    actors_id = actors.collect(&:actors_id).join(', ')
    
    director_id = products_directors_id
    if cat_count > 0
      if !actors_id.empty?
        if director_id
          sql_rank1 = 
          "select p.*  from products p
          join `products_to_categories` pt on pt.products_id = p.products_id
          join products_to_actors pa on p.products_id = pa.products_id
          where products_status != -1 and categories_id in (#{cat_ids}) and `products_directors_id`=#{director_id} and imdb_id !=#{imdb_id}  and actors_id in(#{actors_id})  group by  p.products_id having count(distinct categories_id)>=#{min_cat} and count(distinct actors_id)>=2 limit 50";
          results = ActiveRecord::Base.connection.execute(sql_rank1)
        
          results.each_hash do |h| 
            rank = "#{rank},#{h['products_id']}"
            Recommendation.create(:product_id => self.to_param, :rank => 1, :recommendation_id => h['products_id'])
          end
        end
      end
      if director_id
        sql_rank1 = 
        "select p.*  from products p
        join `products_to_categories` pt on pt.products_id = p.products_id
        where products_status != -1 and categories_id in (#{cat_ids}) and p.products_id not in (#{rank}) and `products_directors_id`=#{director_id} and imdb_id !=#{imdb_id} group by  p.products_id having count(distinct categories_id)>=#{min_cat} limit 50";
        results = ActiveRecord::Base.connection.execute(sql_rank1)
        results.each_hash do |h|
          rank = "#{rank},#{h['products_id']}"
          Recommendation.create(:product_id => self.to_param, :rank => 2, :recommendation_id => h['products_id'])
        end
      end
      if !actors_id.empty?
        sql_rank1 = 
        "select p.*  from products p
        join products_to_actors pa on p.products_id = pa.products_id
        join `products_to_categories` pt on pt.products_id = p.products_id
        where products_status != -1 and categories_id in (#{cat_ids}) and actors_id in(#{actors_id})  and p.products_id not in (#{rank}) and imdb_id !=#{imdb_id} group by  p.products_id having count(distinct categories_id)>=#{min_cat} and count(distinct actors_id)>=2 limit 50";
        results = ActiveRecord::Base.connection.execute(sql_rank1)
        results.each_hash do |h|
          rank = "#{rank},#{h['products_id']}"
          Recommendation.create(:product_id => self.to_param, :rank => 3, :recommendation_id => h['products_id'])
        end
        if director_id
          sql_rank1 = 
          "select p.*  from products p
          join products_to_actors pa on p.products_id = pa.products_id
          where products_status != -1 and actors_id in(#{actors_id})  and p.products_id not in (#{rank}) and imdb_id !=#{imdb_id} and `products_directors_id`=#{director_id} group by  p.products_id having count(distinct actors_id)>=2 limit 50";
          results = ActiveRecord::Base.connection.execute(sql_rank1)
          results.each_hash do |h|
            rank = "#{rank},#{h['products_id']}"
            Recommendation.create(:product_id => self.to_param, :rank => 4, :recommendation_id => h['products_id'])
          end
        end
        sql_rank1 = 
        "select p.*  from products p
        join products_to_actors pa on p.products_id = pa.products_id
        where products_status != -1 and actors_id in(#{actors_id})  and p.products_id not in (#{rank}) and imdb_id !=#{imdb_id} group by  p.products_id having count(distinct actors_id)>=3 limit 50";
        results = ActiveRecord::Base.connection.execute(sql_rank1)
        results.each_hash do |h|
          rank = "#{rank},#{h['products_id']}"
          Recommendation.create(:product_id => self.to_param, :rank => 5, :recommendation_id => h['products_id'])
        end
      end
      sql_rank1 = 
      "select p.*  from products p
      join `products_to_categories` pt on pt.products_id = p.products_id
      join products_availability pa on pa.products_id = p.products_id
      where products_status != -1 and categories_id in (#{cat_ids})  and p.products_id not in (#{rank}) and rating_users/rating_count > 3 and imdb_id !=#{imdb_id} group by  p.products_id having count(distinct categories_id)>=#{cat_count} order by ratio desc limit 50";
      results = ActiveRecord::Base.connection.execute(sql_rank1)
      results.each_hash do |h|
        rank = "#{rank},#{h['products_id']}"
        Recommendation.create(:product_id => self.to_param, :rank => 6, :recommendation_id => h['products_id'])
      end
    else
      puts "not cat"
    end
    
  end
end