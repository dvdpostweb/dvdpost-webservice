class User < ActiveRecord::Base
  belongs_to :customer
  has_and_belongs_to_many :roles, :uniq => true

  validates_presence_of :customer

  def authenticated?(password)
    customer ? customer.authenticated?(password) : false
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user
      user.authenticated?(password) ? user : nil
    else
      customer = Customer.find_by_email(email)
      if customer && customer.authenticated?(password)
        customer.create_user(:email => email, :password => password, :email_confirmed => 1)
      else
        nil
      end
    end
  end

  def active?
    customer ? customer.active? : false
  end

  def has_role?(role)
    roles.include?(role)
  end
end
