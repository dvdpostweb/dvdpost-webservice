class Suspension < ActiveRecord::Base

  attr_reader :duration

  named_scope :holidays, :conditions => {:status => 'HOLIDAYS'}
  named_scope :last_year, :conditions => {:date_added => 1.year.ago..Time.now }

  def self.duration
    duration = OrderedHash.new
    duration.push(7 , :one_weeks  ) 
    duration.push(14, :two_weeks  )
    duration.push(21, :tree_weeks )
    duration.push(30, :one_months )
    duration.push(60, :two_months )
    duration.push(90, :tree_months)
    duration
  end
end