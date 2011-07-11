class HighlightCustomer < ActiveRecord::Base

  named_scope :day, lambda {|day| {:conditions => {:day => day}}}
  named_scope :by_kind, lambda {|kind| {:conditions => {:kind => kind}}}
  
  def self.add_point_by_day
    CustomerPoint.today.destroy_all
    Rating.yesterday.count(:group => 'customers_id').collect do |rating| 
      CustomerPoint.create(:customer_id => rating[0], :points => rating[1])
    end
    Review.yesterday.count(:group => :customers_id).collect do |rating| 
      if customer_point = CustomerPoint.today.find_by_customer_id(rating[0])
        customer_point.update_attribute(:points, customer_point.points + rating[1])
      else
        CustomerPoint.create(:customer_id => rating[0], :points => rating[1])
      end
    end
    ReviewRating.yesterday.collect do |review_rating| 
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
    "add point by day success"
  end

  def self.add_point
    CustomerPoint.today.not_treated.collect do |customer_point|
      customer = Customer.find(customer_point.customer_id) 
      new_point = customer.customer_attribute.points + customer_point.points
      customer_point.update_attribute(:treated, 1)
      customer.customer_attribute.update_attribute(:points, new_point)
    end 
    "add point success"
    
  end

  def self.run_best_customer_all
    HighlightCustomer.day(1).by_kind('all').destroy_all
    HighlightCustomer.day(0).by_kind('all').update_all(:day => 1)
    rank = 0
    
    
    CustomerAttribute.ordered.limit(50).all(:include => :customer, :conditions => {:customers => {:customers_abo => 1}}).collect do |rating|
      rank += 1
      old_position = HighlightCustomer.day(1).by_kind('all').find_by_customer_id(rating[:customer_id])
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightCustomer.create(:customer_id => rating[:customer_id], :rank => rank, :position => position, :day => 0, :kind => 'ALL')
    end
    "best customer all success"
  end

  def self.run_best_customer_month
    HighlightCustomer.day(1).by_kind('month').destroy_all
    HighlightCustomer.day(0).by_kind('month').update_all(:day => 1)
    rank = 0
    
    CustomerPoint.recent.limit(50).sum(:points, :group => :customer_id, :order => 'points desc', :joins => "left join customers c on c.customers_id = customer_id and customers_abo =1 right join reviews r on r.customers_id = customer_id and reviews_check = 1 and date(now()) < DATE_ADD( r.last_modified, INTERVAL 30 DAY )").collect do |customer_point|
      rank += 1
      ratings_count = Customer.find(customer_point[0]).ratings.recent.count
      reviews_count = Customer.find(customer_point[0]).reviews.approved.recent.count
      
      old_position = HighlightCustomer.day(1).by_kind('month').find_by_customer_id(customer_point[0])
      if old_position
        position = old_position.rank - rank
      else
        position = nil
      end
      HighlightCustomer.create(:customer_id => customer_point[0], :rank => rank, :position => position, :day => 0, :kind => 'MONTH', :ratings_count => ratings_count, :reviews_count => reviews_count)
    end
    "best customer month success"
  end

end