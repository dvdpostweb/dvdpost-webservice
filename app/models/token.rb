class Token < ActiveRecord::Base
  belongs_to :customer, :primary_key => :customers_id
  has_many :streaming_product, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :token_ips
  has_many :products, :foreign_key => :imdb_id, :primary_key => :imdb_id

  after_create :generate_token

  validates_presence_of :imdb_id

  named_scope :available,  lambda {{:conditions => {:updated_at => 48.hours.ago..0.hours.ago}}}
  named_scope :unavailable,  lambda {{:conditions => {:updated_at=> 1.weeks.ago..48.hours.ago}}}

  named_scope :recent,  lambda {{:conditions => {:updated_at=> 1.weeks.ago..0.hours.ago}}}  

  named_scope :ordered, :order => 'updated_at asc'
  
  def self.validate(token_param, filename, ip)
    
    token = self.available.find_by_token(token_param)
    if token
      filename = "mp4:#{filename}" 
      filename = filename.sub(/_LOW\.mp4/,'.mp4').sub(/_HIGH\.mp4/,'.mp4')
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
  
  def self.error
    error = OrderedHash.new
    error.push(:abo_process_error, 1)
    error.push(:not_enough_credit, 2)
    error.push(:query_rollback, 3)
    error.push(:user_suspended, 4)
    
    error
  end

  def self.status
    status = OrderedHash.new
    status.push(:ok, 1)
    status.push(:ip_valid, 2)
    status.push(:ip_invalid, 3)
    status.push(:expired, 4)

    status
  end
  
  def expired?
    updated_at < 48.hours.ago
  end

  def current_status(current_ip)
    
    return Token.status[:expired] if expired?
    
    current_ips = token_ips
    return Token.status[:ok] unless current_ips.find_by_ip(current_ip).nil?
    return Token.status[:ip_valid] if current_ips.count < count_ip
    return Token.status[:ip_invalid] 
  end
  
  def validate?(current_ip)
    token_status = current_status(current_ip)
    return token_status == Token.status[:ok] || token_status == Token.status[:ip_valid]
  end
  
=begin
  def validation(imdb_id, ip)
    token = current_customer.tokens.available.find_by_imdb_id(imdb_id)
    if token 
      token_ips = token.token_ips
      select = token_ips.find_by_ip(ip)
      if select
        {:token => token, :status => Token.status[:OK]}
      else
        if token_ips.count < token.count_ip
          
          {:token => token, :status => Token.status[:ip_valid]}
        else
          {:token => token, :status => Token.status[:ip_invalid]}  
        end
      end
    else
      {:token => nil, :status => Token.status[:FAILED]} 
    end
  end
=end

  private
  def generate_token
    update_attribute(:token, Digest::SHA1.hexdigest((created_at.to_s) + (97 * created_at.to_i).to_s))
  end
end
