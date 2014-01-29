class HighlightCustomer < ActiveRecord::Base

  named_scope :day, lambda {|day| {:conditions => {:day => day}}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:kind => kind}}}
  
  def self.add_point_by_day
    CustomerPoint.today.destroy_all
    Rating.yesterday.find(:all,:joins => :product, :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [-2,0,1]}}).collect do |rating| 
      if customer_point = CustomerPoint.today.find_by_customer_id(rating.customers_id)
        customer_point.update_attribute(:points, customer_point.points + 1)
      else
        CustomerPoint.create(:customer_id => rating.customers_id, :points => 1)
      end
    end
    Review.yesterday.approved.find(:all,:joins => :product, :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [-2,0,1]}}).collect do |review| 
      points = 2
    	case review.dvdpost_rating
    		when 2
    			points += 5
    		when 3
    			points += 12
    		when 4
    			points += 25
    		when 5
    			points += 40
    	end
      if customer_point = CustomerPoint.today.find_by_customer_id(review.customers_id)
        customer_point.update_attribute(:points, customer_point.points + points)
      else
        CustomerPoint.create(:customer_id => review.customers_id, :points => points)
      end
    end
    ReviewRating.yesterday.find(:all, :joins => [:review => :product], :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [-2,0,1]}}).collect do |review_rating| 
      if customer_point = CustomerPoint.today.find_by_customer_id(review_rating.customer_id)
        customer_point.update_attribute(:points, customer_point.points + 1)
      else
        CustomerPoint.create(:customer_id => review_rating.customer_id, :points => 1)
      end
      if review_rating.value == 1
        if r = review_rating.review
          if writer = r.customer
            if customer_point = CustomerPoint.today.find_by_customer_id(writer.to_param)
              customer_point.update_attribute(:points, customer_point.points + 1)
            else
              CustomerPoint.create(:customer_id => writer.to_param, :points => 1)
            end
          end
        end
      end
    end
    puts "#{Time.now} add point by day success"
  end

  def self.add_point
    CustomerPoint.today.not_treated.collect do |customer_point|
      customer = Customer.find(customer_point.customer_id) 
      new_point = customer.customer_attribute.points + customer_point.points
      customer_point.update_attribute(:treated, 1)
      customer.customer_attribute.update_attribute(:points, new_point)
    end 
    puts "#{Time.now} add point success"
    
  end

  def self.run_best_customer_all
    HighlightCustomer.day(1).by_kind('all').destroy_all
    HighlightCustomer.day(0).by_kind('all').update_all(:day => 1)
    rank = 0
    
    
    CustomerAttribute.ordered.limit(50).all(:include => :customer, :conditions => {:customers => {:customers_abo => 1}}).collect do |rating|
      rank += 1
      old_position = HighlightCustomer.day(1).by_kind('all').find_by_customer_id(rating[:customer_id])
      ratings_count = Customer.find(rating[:customer_id]).ratings.find(:all,:joins => :product, :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [-2,0,1]}}).count
      reviews_count = Customer.find(rating[:customer_id]).reviews.approved.find(:all,:joins => :product, :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [-2,0,1]}}).count
      
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightCustomer.create(:customer_id => rating[:customer_id], :rank => rank, :position => position, :day => 0, :kind => 'ALL', :ratings_count => ratings_count, :reviews_count => reviews_count)
    end
    puts "#{Time.now} best customer all success"
  end

  def self.run_best_customer_month
    HighlightCustomer.day(1).by_kind('month').destroy_all
    HighlightCustomer.day(0).by_kind('month').update_all(:day => 1)
    rank = 0
    sql= "SELECT  customer_id ,sum(`cp`.points) sum_points
        FROM `customer_points` cp
        join customers c on c.customers_id = customer_id and customers_abo =1 
        WHERE date(now()) < DATE_ADD( cp.created_on, INTERVAL 30 DAY )
        and (
        select count(*) from common_production.reviews r
        join products p on p.imdb_id = r.imdb_id 
        where customers_id = customer_id and reviews_check = 1 and date(now()) < DATE_ADD( r.last_modified, INTERVAL 30 DAY ) and products_type='dvd_norm'
        )>0
        GROUP BY customer_id 
        ORDER BY sum_points desc LIMIT 50;"
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |customer_point|
      rank += 1
      ratings_count = Customer.find(customer_point['customer_id']).ratings.recent.find(:all,:joins => :product, :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [-2,0,1]}}).count
      reviews_count = Customer.find(customer_point['customer_id']).reviews.approved.recent.find(:all,:joins => :product, :conditions => { :products => {:products_type => 'DVD_NORM', :products_status => [-2,0,1]}}).count
      
      old_position = HighlightCustomer.day(1).by_kind('month').find_by_customer_id(customer_point['customer_id'])
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightCustomer.create(:customer_id => customer_point['customer_id'], :rank => rank, :position => position, :day => 0, :kind => 'MONTH', :ratings_count => ratings_count, :reviews_count => reviews_count)
    end
    puts "#{Time.now} best customer month success"
  end

end