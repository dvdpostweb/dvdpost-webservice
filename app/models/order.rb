class Order < ActiveRecord::Base
  set_primary_key :orders_id
  
  def self.lost_by_post
    sql = 'select * from orders o
    join orders_products op on o.orders_id = op.orders_id
    join products_dvd pd on pd.products_id = op.products_id and pd.products_dvdid = op.products_dvd
    where orders_status = 10 and products_dvd_status = 1'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      puts h['products_id']+" "+h['products_dvd']
      product_dvd = ProductsDvd.find(:first, :conditions => {:products_id => h['products_id'], :products_dvdid => h['products_dvd']})
      puts product_dvd.products_dvd_status
      ProductsDvdStatusHistory.create(:status_date => Time.now(),:status_id => 28, :user_id => 55, :previous_status_id => product_dvd.products_dvd_status, :products_id => h['products_id'], :products_dvdid => h['products_dvd'])
      #ProductsDvd.find(:first, :conditions => {:products_id => h['products_id'], :products_dvdid => h['products_dvd']}).update_attribute(:products_dvd_status, 28)
      sql2 = "update products_dvd set products_dvd_status = 28 where products_id = #{h['products_id']} and  products_dvdid = #{h['products_dvd']}"
      ActiveRecord::Base.connection.execute(sql2)
    end
  end
end