class Token < ActiveRecord::Base
  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :streaming_product, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :token_ips
  has_many :products, :foreign_key => :imdb_id, :primary_key => :imdb_id

  after_create :generate_token

  validates_presence_of :imdb_id

  named_scope :available,  lambda {{:conditions => {:updated_at => 48.hours.ago..0.hours.ago}}}
  named_scope :unavailable,  lambda {{:conditions => ["updated_at < ?", 48.hours.ago]}}

  def self.validate(token_param, filename, ip)
    
    token = self.available.find_by_token(token_param)
    if(token)
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

  def self.error
    error = OrderedHash.new
    error.push("ABO_PROCESS", 1)
    error.push("CREDIT", 2)
    error.push("ROLLBACK", 3)
    error.push("SUSPENSION", 4)
    
    error
  end

  def self.status
    status = OrderedHash.new
    status.push("OK", 1)
    status.push("IP_TO_GENERATED", 2)
    status.push("IP_TO_CREATED", 3)
    status.push("FAILED", 4)

    status
  end

  private
  def generate_token
    update_attribute(:token, Digest::SHA1.hexdigest((created_at.to_s) + (97 * created_at.to_i).to_s))
  end
end
