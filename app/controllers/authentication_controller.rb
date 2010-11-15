require 'actionwebservice'

class AuthenticationController < ActionController::Base

=begin
  skip_before_filter :authenticate!
  skip_before_filter :wishlist_size
  skip_before_filter :delegate_locale
  skip_before_filter :messages_size
  skip_before_filter :load_partners
  skip_before_filter :redirect_after_registration
  skip_before_filter :set_locale_from_params
  skip_before_filter :set_country
=end 

  layout nil

  web_service_api AuthenticationApi
  web_service_dispatching_mode :direct
  wsdl_service_name 'ContentAuthenticationService'
  wsdl_namespace 'http://api.service.softlayer.com/soap/v3/'
  web_service_scaffold :invoke

  def Authenticate(strAccount, strToken, strReferrer, strSourceURL, strClientIP)
    begin
      if Token.dvdpost_ip?(strClientIP)
        1
      elsif Rails.env != "production" || strSourceURL =~ CDN.source_file_regexp
        # $3, which represents the filename will be nil for now. It's commented out in the validation of token.
        Token.validate(strToken, $3, strClientIP.strip)
      else
        logger.warn "Authentication failed for #{strAccount}, #{strToken}, #{strReferrer}, #{strSourceURL}, #{strClientIP}"
        0
      end
    rescue => e  
      logger.warn "Authentication failed for #{strAccount}, #{strToken}, #{strReferrer}, #{strSourceURL}, #{strClientIP}"
      0
    end
  end

  def ok
    render :status => :ok
  end
end
