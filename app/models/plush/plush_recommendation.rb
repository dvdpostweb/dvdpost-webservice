class PlushRecommendation < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"
  set_table_name :recommendations
  named_scope :by_imdb_id, lambda {|imdb_id| {:conditions => {:imdb_id => imdb_id}}}
  def self.generate
    puts "best see"
    generate_best_see
    puts "best other"
    generate_left_product
  end
  def self.generate_best_see
    PlushToken.all(:group =>'imdb_id').each do |item|
      if item.plush_products.size > 0
        puts "products #{item.plush_products.first.products_id}"
        customer_already_see(item.imdb_id)
      end
    end

    return nil
  end
  def self.generate_left_product
    env = Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging'
    sql ="select p.imdb_id from plush_#{env}.products p
left join plush_#{env}.recommendations r on p.imdb_id = r.imdb_id
where (r.imdb_id is null or r.updated_at < date_add(now(),interval -2 day)) and p.products_status !=-1 and p.imdb_id >0
group by p.imdb_id;"
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h|
      product = PlushProduct.find_by_imdb_id(h['imdb_id'])
      if product
        puts "products #{product.products_id}"
        product_best_see(product.imdb_id)
      end
    end
  end

  def self.product_best_see(imdb_id)
    product = PlushProduct.find_by_imdb_id(imdb_id)
    categories = product.plush_categories.collect(&:id).join(',')
    country = product.products_countries_id
    direction = categories.include?('99') ? "desc" : "asc"
    env = Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging'
    if !categories.empty?
      sql = "select imdb_id , products_title , products_countries_id, sum(nb) nb, year, cat, country_match, force_cat from ( 
select  products_countries_id,products_year year,count(*)nb,(select count(*) from plush_#{env}.products_to_categories where products_id = p.products_id and categories_id in (#{categories})) cat, p.imdb_id , p.products_title, if(products_countries_id = #{country},1,0) country_match
 ,(select count(*) from plush_#{env}.products_to_categories where products_id = p.products_id and categories_id in (99)) force_cat
 from plush_#{env}.products p 
 left join plush_#{env}.tokens t on t.imdb_id = p.imdb_id
 where products_status!=-1 and p.imdb_id != #{imdb_id} and p.imdb_id != 0 
 group by imdb_id
 union
 select  p.products_countries_id,p.products_year year,count(*)nb,(select count(*) from dvdpost_be_prod.products_to_categories where products_id = p.products_id and categories_id in (#{categories})) cat, p.imdb_id , p.products_title, if(p.products_countries_id = #{country},1,0) country_match
 ,(select count(*) from dvdpost_be_prod.products_to_categories where products_id = p.products_id and categories_id in (99)) force_cat
 from dvdpost_be_prod.products p 
 join plush_#{env}.products pp on p.products_id = pp.products_id 
 left join dvdpost_be_prod.tokens t on t.imdb_id = p.imdb_id and p.imdb_id != 0
 where pp.products_status!=-1 and p.imdb_id != #{imdb_id}
 group by p.imdb_id) t
 group by imdb_id 
 order by force_cat asc, cat desc,nb desc,  country_match desc, year desc limit 25;"
      i = 0
      PlushRecommendation.by_imdb_id(imdb_id).destroy_all()
      results = ActiveRecord::Base.connection.execute(sql)
      results.each_hash do |h|
        i = i + 1
        PlushRecommendation.create(:imdb_id => imdb_id, :recommendation_id => h['imdb_id'], :position => i)
      end
    else
      puts "no cat"
    end
  end
  def self.customer_already_see(imdb_id)
    product = PlushProduct.find_by_imdb_id(imdb_id)
    categories = product.plush_categories.collect(&:id).join(',')
    country = product.products_countries_id
    direction = categories.include?('99') ? "desc" : "asc"
    env = Rails.env == 'production' || Rails.env == 'pre_production' ? 'production': 'staging'
    if !categories.empty?
      sql =  "select imdb_id , products_title , products_countries_id, sum(nb) nb, year, cat, country_match, force_cat from (
select products_countries_id,count(*)nb,products_year year,(select count(*) from plush_#{env}.products_to_categories where products_id = p.products_id and categories_id in (#{categories})) cat, t.imdb_id , p.products_title, if(products_countries_id = #{country},1,0) country_match
 ,(select count(*) from plush_#{env}.products_to_categories where products_id = p.products_id and categories_id in (99)) force_cat
 from plush_#{env}.tokens t
 join plush_#{env}.products p on t.imdb_id = p.imdb_id
 join
 (select customer_id from plush_#{env}.products p
 join plush_#{env}.tokens t on t.imdb_id = p.imdb_id
 where p.imdb_id = #{imdb_id}) c on c.customer_id = t.customer_id
 where t.imdb_id !=#{imdb_id} and products_status !=-1
 group by t.imdb_id
 union
select p.products_countries_id,count(*)nb,p.products_year year,(select count(*) from dvdpost_be_prod.products_to_categories where products_id = p.products_id and categories_id in (#{categories})) cat, t.imdb_id , p.products_title, if(p.products_countries_id = #{country},1,0) country_match
 ,(select count(*) from dvdpost_be_prod.products_to_categories where products_id = p.products_id and categories_id in (99)) force_cat
 from dvdpost_be_prod.tokens t
 join plush_#{env}.products pp on t.imdb_id = pp.imdb_id
 join dvdpost_be_prod.products p on t.imdb_id = p.imdb_id
 join
 (select customer_id from dvdpost_be_prod.products p
 join dvdpost_be_prod.tokens t on t.imdb_id = p.imdb_id
 where p.imdb_id = #{imdb_id}) c on c.customer_id = t.customer_id
 where t.imdb_id !=#{imdb_id} and t.imdb_id != 0 and pp.products_status !=-1
 group by t.imdb_id 
 ) t
 group by imdb_id
 order by force_cat asc, cat desc, nb desc,country_match desc, year desc limit 25;
            "


      i = 0
      PlushRecommendation.by_imdb_id(imdb_id).destroy_all()
      results = ActiveRecord::Base.connection.execute(sql)
      results.each_hash do |h|
        i = i + 1
        PlushRecommendation.create(:imdb_id => imdb_id, :recommendation_id => h['imdb_id'], :position => i)
      end
    else
      puts "no cat"
    end
  end
end
