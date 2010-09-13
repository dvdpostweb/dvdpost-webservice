require 'actionwebservice'

class AuthenticationController < ApplicationController
  web_service_api AuthenticationApi
  web_service_dispatching_mode :direct
  wsdl_service_name 'ContentAuthenticationService'
  wsdl_namespace 'http://api.service.softlayer.com/soap/v3/'
  web_service_scaffold :invoke

  def Authenticate(strAccount, strToken, strReferrer, strSourceURL, strClientIP)
    logger.debug("#{strAccount}, #{strToken}, #{strReferrer}, #{strSourceURL}, #{strClientIP}, #{strClientIP.strip}")
    begin
    
      if strSourceURL =~ CDN.source_file_regexp
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
