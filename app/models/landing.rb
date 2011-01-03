class Landing < ActiveRecord::Base
  has_one :product, :primary_key => :reference_id, :foreign_key => :products_id

  named_scope :order, lambda {|order| {:order => "expirated_date #{order}, id desc"}}
  named_scope :not_expirated, :conditions => 'expirated_date > now()'
  named_scope :expirated, :conditions => 'expirated_date < now()'
  named_scope :private, :conditions => {:login => true}
  named_scope :limit, lambda {|limit| {:limit => limit}}
  named_scope :by_language, lambda {|language| {:conditions => {(language == :nl ? :actif_dutch : (language == :en ? :actif_english : :actif_french)) => "YES"}}}

  def image
    File.join(DVDPost.images_carousel_path, id.to_s+'.jpg')
  end
end
