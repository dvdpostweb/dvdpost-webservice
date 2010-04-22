class Banner < ActiveRecord::Base
  set_primary_key :banners_id

  alias_attribute :url, :banners_url
  alias_attribute :group, :banners_group
  alias_attribute :title, :banners_title
  alias_attribute :size, :banners_group
  alias_attribute :banner, :banners_image

  named_scope :by_language, lambda {|language| {:conditions => {(language == :nl ? :active_nl : (language == :en ? :active_en : :status)) => 1}}}
  named_scope :by_size, lambda {|size| {:conditions => {:banners_group => DVDPost.banner_size[size]}}}
  named_scope :expiration, :conditions => ["expires_date > ? or expires_date is null ", Time.now]

  def image
    File.join(DVDPost.images_shop_path[I18n.locale], banner) if  !banner.empty?
  end
end
