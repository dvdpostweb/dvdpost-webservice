class Landing < ActiveRecord::Base
  has_one :product, :primary_key => :reference_id, :foreign_key => :products_id

  named_scope :order, :order => "expirated_date desc"
  named_scope :by_expiration, :conditions => "expirated_date > now() "
  named_scope :private, :conditions => {:login => true}
  named_scope :limit, :limit => 5
  
  
  def image
    File.join(DVDPost.images_carousel_path, id.to_s+'.jpg')
  end
end