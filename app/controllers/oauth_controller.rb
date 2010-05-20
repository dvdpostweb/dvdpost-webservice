class OauthController < ApplicationController
  def start
    redirect_to client.web_server.authorize_url(
      :redirect_uri => oauth_callback_url
    )
  end

  def callback
    access_token = client.web_server.get_access_token(
      params[:code], :redirect_uri => oauth_callback_url
    )

    user_json = access_token.get('/me')
    
    render :json => user_json
  end
end
