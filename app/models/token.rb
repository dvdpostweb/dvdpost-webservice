class Token < ActiveRecord::Base
  validates_presence_of :filename, :expires_at, :ip
  validates_format_of :ip, :with => /\A(?:25bo[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/

  after_create :generate_token

  def self.validate(token_param, filename, ip)
    token = self.find_by_token(token_param)
    if token && token.ip == ip && token.expires_at > Time.now.to_date # && token.filename == filename
      1
    else
      0
    end
  end

  private
  def generate_token
    update_attribute(:token, Digest::SHA1.hexdigest((ip + filename + expires_at.to_s) + (97 * created_at.to_i).to_s))
  end
end
