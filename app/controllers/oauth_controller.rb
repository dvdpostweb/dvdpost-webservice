class OauthController < ApplicationController
  skip_before_filter :authenticate!
  
  def unauthenticated
    puts 'unauthenticated'
    redirect_to oauth_client.web_server.authorize_url(
      :redirect_uri => oauth_callback_url
    )
  end

  def callback
    access_token = oauth_client.web_server.get_access_token(
      params[:code], :redirect_uri => oauth_callback_url
    )

    user_json = access_token.get('/me')
    
    render :json => user_json
  end
end
