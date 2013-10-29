# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'open-uri'
require 'rss/2.0'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
#  helper_method :current_customer
#
#  before_filter :save_attempted_path
#  before_filter :authenticate!, :unless => :is_special_page?
#  before_filter :wishlist_size
#  before_filter :indicator_close?
#  before_filter :delegate_locale
#  before_filter :messages_size, :unless => :is_it_js?
#  before_filter :load_partners, :unless => :is_it_js?
#  before_filter :redirect_after_registration
#  before_filter :set_locale_from_params
#  before_filter :set_country
#  before_filter :get_wishlist_source
#  before_filter :last_login, :unless => :is_it_js?
  
  rescue_from ::ActionController::MethodNotAllowed do |exception|
    logger.warn "*** #{exception} Path: #{request.path} ***"
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password





  
end
