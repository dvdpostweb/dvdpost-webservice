# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate
  before_filter :wishlist_size

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def current_customer
    current_user.customer if current_user
  end

  def wishlist_size
    @wishlist_size = current_customer.wishlist_items.count || 0 unless current_customer.nil?
  end
end
