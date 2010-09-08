class TokenIp < ActiveRecord::Base
  validates_format_of :ip, :with => /\A(?:25bo[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/
  
  belongs_to :token
end
