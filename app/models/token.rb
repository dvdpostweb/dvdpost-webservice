class Token < ActiveRecord::Base
  validates_format_of :ip, :with => /\A(?:25bo[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/

  belongs_to :customer, :foreign_key => :customers_id

  after_create :generate_token

  named_scope :available,  lambda {{:conditions => {:created_at => (Time.now - 48.hours)..Time.now}}}

  def self.validate(token_param, filename, ip)
    token = self.find_by_token(token_param)
    if token && token.ip == ip && token.created_at > 2.day.ago # && token.filename == filename
      1
    else
      0
    end
  end

  def restriction(customer_ip)
    if ip == customer_ip
      true
    else
      false
    end
  end

  private
  def generate_token
    update_attribute(:token, Digest::SHA1.hexdigest((ip + created_at.to_s) + (97 * created_at.to_i).to_s))
  end
end
