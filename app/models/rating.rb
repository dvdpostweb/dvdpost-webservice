class Rating < ActiveRecord::Base
  set_table_name :products_rating

  set_primary_key :products_rating_id

  alias_attribute :updated_at, :products_rating_date
  alias_attribute :type,       :rating_type
  alias_attribute :value,      :products_rating
  alias_attribute :product_id,      :products_id

  named_scope :by_customer, lambda {|customer| {:conditions => {:customers_id => customer.to_param}}}
  named_scope :limit, lambda {|limit| {:limit => limit}}
  named_scope :ordered, :order => 'count_all desc'
  named_scope :group_by_product, :group => 'products_id'
  named_scope :recent,  lambda {{:conditions => {:products_rating_date => 30.days.ago.localtime.midnight..Time.now.localtime.end_of_day}}}  
  
  def self.make_best_rating
    HighlightProduct.day(1).by_kind('best').destroy_all
    HighlightProduct.day(0).by_kind('best').update_all(:day => 1)
    rank = 0
    Rating.recent.limit(27).average(:products_rating, :group => :products_id, :order => 'avg_products_rating desc, count(*) desc', :having => 'count(*)>3').collect do |rating|
      rank += 1
      old_position = HighlightProduct.day(1).by_kind('best').find_by_product_id(rating[0])
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightProduct.create(:product_id => rating[0], :rank => rank, :position => position, :day => 0)
    end
  end
  
  def self.make_controverse_rating(language_id)
    sql = "select distinct(products_id),
    (SELECT count(*) nb FROM `products_rating` r2 WHERE date(now()) < DATE_ADD( r2.products_rating_date, INTERVAL 30 DAY ) and r2.products_rating <3 and r2.products_id = r.products_id ) minder
    ,(SELECT count(*) nb FROM `products_rating` r2 WHERE date(now()) < DATE_ADD( r2.products_rating_date, INTERVAL 30 DAY ) and r2.products_rating >3 and r2.products_id = r.products_id ) plus
    ,(select count(*) from reviews re where reviews_check = 1 and re.products_id = r.products_id and languages_id = #{language_id}) reviews
    FROM `products_rating` r
    WHERE (date(now()) < DATE_ADD( r.products_rating_date, INTERVAL 30 DAY )) 
    having (minder + plus) >3 and reviews > 3
    order by  abs(minder - plus) asc, plus desc
    limit 30"
    HighlightProduct.day(0).by_language(language_id).by_kind('controverse').destroy_all
    results = ActiveRecord::Base.connection.execute(sql)
    rank = 0
    results.each_hash do |h| 
      rank += 1
      HighlightProduct.create(:product_id => h['products_id'], :rank => rank, :position => nil, :day => 0, :kind => 'controverse', :language_id => language_id)
    end
  end
end