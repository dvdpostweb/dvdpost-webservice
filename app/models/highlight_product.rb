class HighlightProduct < ActiveRecord::Base

  named_scope :day, lambda {|day| {:conditions => {:day => day}}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:kind => kind}}}
  named_scope :by_language, lambda {|language| {:conditions => {:language_id => language}}}
  
  def self.run_best_rating
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

  def self.run_controverse_rating
    3.times do |i|
      language = i+1
      self.run_controverse_rating_by_language(language)
    end 
  end
private  
  def self.run_controverse_rating_by_language(language_id)
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