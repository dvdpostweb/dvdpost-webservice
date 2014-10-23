class PlushToken < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"
  set_table_name :tokens
  has_many :plush_products, :primary_key => :imdb_id, :foreign_key => :imdb_id

  named_scope :available,  lambda {{:conditions => {:updated_at => 48.hours.ago.localtime..0.hours.ago.localtime}}}
  
    
  def self.validate(token_param, filename, ip)
    token = self.available.find_by_token(token_param)
    if token
      filename = "mp4:#{filename}" 
      filename_select = StreamingProduct.by_filename(filename).all(:include => :tokens, :conditions => ['tokens.id = ?', token.id])
      token_ips = token.token_ips
      select = token_ips.find_by_ip(ip)
    end
    if token && select && !filename_select.blank?
      1
    else
      0
    end
  end

  def self.dvdpost_ip?(client_ip)
    if client_ip == DVDPost.dvdpost_ip[:internal]
      return true
    else
      DVDPost.dvdpost_ip[:external].each do |external|
        if client_ip == external
          return true
        end
      end
      return false
    end
  end
end
