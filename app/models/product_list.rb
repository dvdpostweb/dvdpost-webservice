class ProductList < ActiveRecord::Base
  has_and_belongs_to_many :products, :join_table => :listed_products, :order => 'listed_products.order asc'

  named_scope :top, :conditions => {:kind => 'TOP'}
  named_scope :theme, :conditions => {:kind => 'THEME'}
  named_scope :status, :conditions => {:status => true}
  named_scope :not_highlighted, :conditions => {:home_page => false}
  named_scope :highlighted, :conditions => {:home_page => true} 
  named_scope :by_language, lambda {|language| {:conditions => {:language => language}}}
  
end
