# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'open-uri'
require 'rss/2.0'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_customer

  before_filter :save_attempted_path
  before_filter :authenticate!
  before_filter :wishlist_size
  before_filter :delegate_locale
  before_filter :messages_size
  before_filter :load_partners
  before_filter :redirect_after_registration
  before_filter :set_locale_from_params

  rescue_from ActionController::MethodNotAllowed do |exception|
    logger.warn "*** #{exception} Path: #{request.path} ***"
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end

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
    params[:locale]||='fr'
    available_locales.include?(params[:locale].to_sym) ? params[:locale] : nil
  end

  def default_url_options(options={})
    options.keys.include?(:locale) ? options : options.merge( :locale => I18n.locale )
  end

  private
  def http_authenticate
    authenticate_or_request_with_http_basic do |id, password|
      id == 'dvdpostadmin' && password == 'Chase-GiorgioMoroder@dvdpost'
    end
    warden.custom_failure! if performed?
  end
end
