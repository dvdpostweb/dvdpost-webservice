# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'open-uri'
require 'rss/2.0'
require 'geo_ip'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_customer

  before_filter :save_attempted_path
  before_filter :authenticate!
  before_filter :wishlist_size
  before_filter :delegate_locale
  before_filter :messages_size, :unless => :is_it_js?
  before_filter :load_partners, :unless => :is_it_js?
  before_filter :redirect_after_registration
  before_filter :set_locale_from_params
  before_filter :set_country
  before_filter :last_login, :unless => :is_it_js?
  

  rescue_from ::ActionController::MethodNotAllowed do |exception|
    logger.warn "*** #{exception} Path: #{request.path} ***"
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  
  def is_it_js?
    request.format.js?
  end
  
  def set_locale_from_params
    locale = extract_locale_from_params
    locale = current_customer.update_locale(locale) if current_customer
    set_locale(locale || :fr)
  end

  def last_login
    if current_customer
      if !session[:last_login]
        current_customer.update_attributes(:login_count  =>  (current_customer.login_count + 1), :last_login_at => Time.now.to_s(:db) )
        session[:last_login] = true
      end
    end
  end

  def set_country
     if !session[:country_code]
       geo = GeoIp.geolocation(request.remote_ip, {:precision => :country})
       country_code = geo[:country_code]
       session[:country_code] = country_code
     else
       country_code = session[:country_code]
     end
  end
  
  def available_locales
    AVAILABLE_LOCALES
  end

  def extract_locale_from_params
    locale = params[:locale].to_sym unless params[:locale].blank?
    locale if available_locales.include?(locale)
  end

  def default_url_options(options={})
    options.keys.include?(:locale) ? options : options.merge(:locale => I18n.locale)
  end

  private
  def http_authenticate
    authenticate_or_request_with_http_basic do |id, password|
      id == 'dvdpostadmin' && password == 'Chase-GiorgioMoroder@dvdpost'
    end
    warden.custom_failure! if performed?
  end
end
