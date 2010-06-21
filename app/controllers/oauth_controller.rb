class OauthController < ApplicationController
  skip_before_filter :authenticate!

  def authenticate
    redirect_to oauth_client.web_server.authorize_url(
      :redirect_uri => oauth_callback_url
    )
  end

  # This code probably doesn't belong here
  # It's just here for testing purposes
  # Jeroen
  def refresh
    access_token = oauth_client.web_server.refresh_access_token(session[:refresh_token])

    session[:oauth_token] = access_token.token
    session[:expires_in] = access_token.expires_in
    session[:refresh_token] = access_token.refresh_token

    output = "#{session[:oauth_token]}\n"
    output = "#{output}#{session[:expires_in]}\n"
    output = "#{output}#{session[:refresh_token]}\n"
    render :text => output
  end

  def callback
    access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => oauth_callback_url)

    session[:oauth_token] = access_token.token
    session[:expires_in] = access_token.expires_in
    session[:refresh_token] = access_token.refresh_token

    attempted_path = session[:attempted_path]

    redirect_to attempted_path ? attempted_path : root_path
  end

  def logout
    warden.logout
    redirect_to sso_sign_out_path
  end
end
