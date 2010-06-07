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
  before_filter :load_partners

  before_filter :set_locale_from_params

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def set_locale_from_params
    logger.debug "* Available locales are: #{available_locales.inspect}"
    set_locale(extract_locale_from_params || I18n.default_locale)
    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  def available_locales
    AVAILABLE_LOCALES
  end

  def extract_locale_from_params
    (available_locales.include? params[:locale]) ? params[:locale] : nil
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    options.keys.include?(:locale) ? options : options.merge( :locale => I18n.locale )
  end
end
