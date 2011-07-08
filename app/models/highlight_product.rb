class HighlightProduct < ActiveRecord::Base

  named_scope :day, lambda {|day| {:conditions => {:day => day}}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:kind => kind}}}
  named_scope :by_language, lambda {|language| {:conditions => {:language_id => language}}}
  
  def self.run_best_rating
    HighlightProduct.day(1).by_kind('best').destroy_all
    HighlightProduct.day(0).by_kind('best').update_all(:day => 1)
    rank = 0
    Rating.recent.limit(27).average(:products_rating, :group => "products_rating.products_id", :order => 'avg_products_rating desc, count(*) desc', :having => 'count(*)>3', :joins => "left join products on products.products_id = products_rating.products_id and products_status !=1 and products_type='dvd_norm'").collect do |rating|
      count = Rating.recent.find_all_by_products_id(rating[0]).count
      rank += 1
      old_position = HighlightProduct.day(1).by_kind('best').find_by_product_id(rating[0])
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightProduct.create(:product_id => rating[0], :rank => rank, :position => position, :day => 0, :average => ((rating[1]*100).round).to_f/100, :count => count)
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
    sql = "select distinct(r.products_id),
    (SELECT count(*) nb FROM dvdpost_be_prod.`products_rating` r2 WHERE date(now()) < DATE_ADD( r2.products_rating_date, INTERVAL 30 DAY ) and r2.products_rating <3 and r2.products_id = r.products_id ) minder
    ,(SELECT count(*) nb FROM dvdpost_be_prod.`products_rating` r2 WHERE date(now()) < DATE_ADD( r2.products_rating_date, INTERVAL 30 DAY ) and r2.products_rating >3 and r2.products_id = r.products_id ) plus
    FROM dvdpost_be_prod.`products_rating` r 
    join products p on p.products_id = r.products_id "
    if language_id == 1
      sql += 'join dvdpost_be_prod.products_to_languages pl on r.products_id = pl.products_id and products_languages_id = 1'
    elsif language_id == 2
      sql += 'join dvdpost_be_prod.products_to_undertitles pl on r.products_id = pl.products_id and products_undertitles_id = 2'
    else
      sql += 'join dvdpost_be_prod.products_to_languages pl on r.products_id = pl.products_id and products_languages_id = 3'
    end
    
    sql += " WHERE (date(now()) < DATE_ADD( r.products_rating_date, INTERVAL 30 DAY )) and products_type='dvd_norm' and products_status !=-1
    having (minder + plus) >3 and minder > 1 and plus > 1 and abs(minder - plus) <4
    order by   plus desc,abs(minder - plus) asc
    limit 30"
    Rails.logger.debug { "@@@@#{sql}" }
    HighlightProduct.day(0).by_language(language_id).by_kind('controverse').destroy_all
    results = ActiveRecord::Base.connection.execute(sql)
    rank = 0
    results.each_hash do |h| 
      rank += 1
      HighlightProduct.create(:product_id => h['products_id'], :rank => rank, :position => nil, :day => 0, :kind => 'controverse', :language_id => language_id, :plus => h['plus'], :minder => h['minder'])
    end
  end
end