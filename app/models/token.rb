class Token < ActiveRecord::Base
  belongs_to :customer, :foreign_key => :customers_id
  has_many :token_ips
  has_many :products, :foreign_key => :imdb_id, :primary_key => :imdb_id

  after_create :generate_token

  named_scope :available,  lambda {{:conditions => {:created_at => 48.hours.ago..0.hours.ago}}}

  def self.validate(imdb_id, ip, type = 'external' )
    token = self.available.find_by_imdb_id(imdb_id)
    if token 
      token_ips = token.token_ips
      select = token_ips.find_by_ip(ip)
      if select
        type == 'external' ? 1 : token
      else
        if token_ips.count < 2
          token_ip = TokenIp.create(
            :token_id => token.id,
            :ip => ip
          )
          type == 'external' ? 1 : token
        else
          type == 'external' ? 0 : nil
        end
      end
    else
      type == 'external' ? 0 : nil
    end
  end

  private
  def generate_token
    update_attribute(:token, Digest::SHA1.hexdigest((created_at.to_s) + (97 * created_at.to_i).to_s))
  end
end
