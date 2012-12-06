class HighlightProduct < ActiveRecord::Base

  named_scope :day, lambda {|day| {:conditions => {:day => day}}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:kind => kind}}}
  named_scope :by_language, lambda {|language| {:conditions => {:language_id => language}}}
  def self.run_best_rating
    3.times do |i|
      language = i+1
      self.run_best_rating_by_language(language)
      puts "#{Time.now} best language : #{language} success"
    end 
    
  end
  def self.run_best_rating_by_language(language_id)
    HighlightProduct.day(1).by_language(language_id).by_kind('best').destroy_all
    HighlightProduct.day(0).by_language(language_id).by_kind('best').update_all(:day => 1)
    if language_id == 1
      join  = 'join dvdpost_be_prod.products_to_languages  on products.products_id = products_to_languages.products_id and products_languages_id = 1'
    elsif language_id == 2
      join = 'join dvdpost_be_prod.products_to_undertitles  on products.products_id = products_to_undertitles.products_id and products_undertitles_id = 2'
    else
      join = 'join dvdpost_be_prod.products_to_languages  on products.products_id = products_to_languages.products_id and products_languages_id = 3'
    end
    rank = 0
    Rating.recent.limit(40).average(:products_rating, :group => "products_rating.imdb_id", :order => 'count(distinct products_rating.customers_id) desc, avg_products_rating desc', :having => 'count(distinct products_rating.customers_id)>=3 and avg_products_rating >= 3.6', :joins => "join products on products.products_id = products_rating.products_id and products_status !=-1 and products_type='dvd_norm' and products.imdb_id > 0 #{join}").collect do |rating|
      count = Rating.recent.by_imdb_id(rating[0]).all(:select => 'distinct(customers_id)').count
      product = Rating.recent.find_all_by_imdb_id(rating[0]).first
      rank += 1
      old_position = HighlightProduct.day(1).by_kind('best').by_language(language_id).find_by_product_id(product.products_id)
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightProduct.create(:product_id => product.products_id, :rank => rank, :position => position, :day => 0, :average => ((rating[1]*100).round).to_f/100, :count => count, :language_id => language_id)
    end
  end
  def self.run_best_rating_vod
    3.times do |i|
      language = i+1
      self.run_best_rating_vod_by_language(language,'BE')
      self.run_best_rating_vod_by_language(language,'LU')
      puts "#{Time.now} best language : #{language} success"
    end 
    
  end
  def self.run_best_rating_vod_by_language(language_id, country)
    kind_key = country=='LU' ? 'BEST_VOD_LU' : 'BEST_VOD_BE'
    HighlightProduct.day(1).by_language(language_id).by_kind(kind_key).destroy_all
    HighlightProduct.day(0).by_language(language_id).by_kind(kind_key).update_all(:day => 1)
    join = "join streaming_products on products.imdb_id = streaming_products.imdb_id 
    and streaming_products.status = 'online_test_ok' and available = 1 and (language_id =#{language_id} or subtitle_id=#{language_id}) and
    ((streaming_products.available_from <= date(now())  and streaming_products.expire_at >= date(now())) or
    (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now())))"
    if country=='LU'
      join = "#{join} join studio on streaming_products.studio_id = studio.studio_id and vod_lux=1"
    end
    rank = 0
    Rating.recent.limit(40).average(:products_rating, :group => "products_rating.imdb_id", :order => 'count(distinct products_rating.customers_id) desc, avg_products_rating desc', :having => 'count(distinct products_rating.customers_id)>=2 and avg_products_rating >= 3.6', :joins => "join products on products.products_id = products_rating.products_id and products_status !=-1 and products_type='dvd_norm' and products.imdb_id > 0 #{join}").collect do |rating|
      count = Rating.recent.by_imdb_id(rating[0]).all(:select => 'distinct(customers_id)').count
      product = Rating.recent.find_all_by_imdb_id(rating[0]).first
      rank += 1
      old_position = HighlightProduct.day(1).by_kind().by_language(language_id).find_by_product_id(product.products_id)
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightProduct.create(:product_id => product.products_id,:kind =>kind_key, :rank => rank, :position => position, :day => 0, :average => ((rating[1]*100).round).to_f/100, :count => count, :language_id => language_id)
    end
  end
  def self.run_controverse_rating
    3.times do |i|
      language = i+1
      self.run_controverse_rating_by_language(language)
      puts "#{Time.now} controvese language : #{language} success"
    end 
    
  end
private  
  def self.run_controverse_rating_by_language(language_id)
    sql = "select distinct(r.products_id), (SELECT count(*) nb FROM dvdpost_be_prod.`products_rating` r2 WHERE date(now()) < DATE_ADD( r2.products_rating_date, INTERVAL 30 DAY ) and r2.products_rating <3 and r2.products_id = r.products_id ) minder ,(SELECT count(*) nb FROM dvdpost_be_prod.`products_rating` r2 WHERE date(now()) < DATE_ADD( r2.products_rating_date, INTERVAL 30 DAY ) and r2.products_rating >3 and r2.products_id = r.products_id ) plus FROM dvdpost_be_prod.`products_rating` r 
    join products p on p.products_id = r.products_id "
    if language_id == 1
      sql += 'join dvdpost_be_prod.products_to_languages pl on r.products_id = pl.products_id and products_languages_id = 1'
    elsif language_id == 2
      sql += 'join dvdpost_be_prod.products_to_undertitles pl on r.products_id = pl.products_id and products_undertitles_id = 2'
    else
      sql += 'join dvdpost_be_prod.products_to_languages pl on r.products_id = pl.products_id and products_languages_id = 3'
    end
    
    sql += " WHERE (date(now()) < DATE_ADD( r.products_rating_date, INTERVAL 30 DAY )) and products_type='dvd_norm' and p.imdb_id > 0 and products_status !=-1
    having (minder + plus) >3 and minder > 1 and plus > 1 and abs(minder - plus) <4
    order by   plus desc,abs(minder - plus) asc
    limit 27"
    HighlightProduct.day(0).by_language(language_id).by_kind('controverse').destroy_all
    results = ActiveRecord::Base.connection.execute(sql)
    rank = 0
    results.each_hash do |h| 
      rank += 1
      HighlightProduct.create(:product_id => h['products_id'], :rank => rank, :position => nil, :day => 0, :kind => 'controverse', :language_id => language_id, :plus => h['plus'], :minder => h['minder'])
    end
  end
end