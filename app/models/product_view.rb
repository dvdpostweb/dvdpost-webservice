class ProductView < ActiveRecord::Base
  named_scope :daily, :conditions => ['date(created_at) = :date', {:date => Time.now.strftime('%Y-%m-%d')}]
end