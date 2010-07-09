class OauthController < ApplicationController
  skip_before_filter :save_attempted_path
  skip_before_filter :authenticate!

  def authenticate
    # We need to send the locale so that SSO is in the correct locale
    # If we use I18n.locale it will default back to :fr if there is no locale param given
    # This means that we have to parse it out of the uri, so that we do not send a locale if it's has no locale param
    # If there is a locale here, this will be the locale when we get redirected back (The one from SSO will get lost)
    # If there is no locale, the one that SSO sets for us will be used in this client app
    locale = $1 if request.path.match /\/(#{available_locales.join('|')})(\/.*|)/
    options = {:redirect_uri => oauth_callback_url(:locale => locale)}
    options.merge!(:locale => locale) if locale
    redirect_to oauth_client.web_server.authorize_url(options)
  end

  def callback
    access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => oauth_callback_url)

    session[:oauth_token] = access_token.token
    session[:expires_in] = access_token.expires_in
    session[:refresh_token] = access_token.refresh_token
    
    unless access_token.refresh_token.blank?
      cookies[:oauth_token] = { :value => access_token.token, :expires => 10.year.from_now }
      cookies[:expires_in] = { :value => access_token.expires_in, :expires => 10.year.from_now }
      cookies[:refresh_token] = { :value => access_token.refresh_token, :expires => 10.year.from_now }
    end

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
