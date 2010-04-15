class User < ActiveRecord::Base
  include Clearance::User

  has_and_belongs_to_many :roles, :uniq => true

  def authenticated?(password)
    customer = Customer.find_by_email(email)
    customer ? customer.authenticated?(password) : false
  end

  def self.authenticate(email, password)
    Customer.authenticate(email, password)
  end

  def active?
    customer = Customer.find_by_email(email)
    customer ? customer.active? : false
  end

  def customer
    Customer.find_by_email(email)
  end
end
