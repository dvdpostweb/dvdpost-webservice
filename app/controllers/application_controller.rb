# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'open-uri'
require 'rss/2.0'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_customer

  before_filter :authenticate!
  before_filter :wishlist_size
  before_filter :delegate_locale
  before_filter :messages_size

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

end
