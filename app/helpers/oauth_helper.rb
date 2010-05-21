module OauthHelper
  def authorize
    verify_token_remote
  end

  def verify_token_remote
    authorized = false
    if oauth_token
      response = endoauth_token.get '/validate_token'
      authorized = response.status == 200
    end
    authorized
  end
end
