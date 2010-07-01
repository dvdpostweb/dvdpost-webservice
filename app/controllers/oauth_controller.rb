class OauthController < ApplicationController
  skip_before_filter :authenticate!

  def authenticate
    redirect_to oauth_client.web_server.authorize_url(:redirect_uri => oauth_callback_url, :locale => I18n.locale)
  end

  def callback
    access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => oauth_callback_url)

    session[:oauth_token] = access_token.token
    session[:expires_in] = access_token.expires_in
    session[:refresh_token] = access_token.refresh_token

    attempted_path = session[:attempted_path]

    redirect_to attempted_path ? attempted_path : root_path
  end

  def sign_out
    begin
      json = oauth_token.post('/sign_out')
      logger.info "*** SSO Response after sign_out: #{json}"
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace
      # Catching sign_out silently because this means that either oauth_token and/or refresh_token are invalid
      # This means that the client already is logged out
      logger.error '*** sign_out on SSO failed but is caught silently ***'
    end
    logout
    redirect_to redirect_url_after_sign_out
  end
end
