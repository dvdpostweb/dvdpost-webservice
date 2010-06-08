Rails.configuration.middleware.use RailsWarden::Manager, :defaults               => :dvdpost_oauth,
                                                         :failure_app            => 'oauth_controller',
                                                         :unauthenticated_action => :authenticate do |manager|
  manager.oauth(:dvdpost) do |sso_dvdpost|
    params = OAUTH.clone

    sso_dvdpost.client_secret = params.delete(:client_secret)
    sso_dvdpost.client_id = params.delete(:client_id)
    sso_dvdpost.options = params
  end
end

# Setup Session Serialization
class Warden::SessionSerializer
  def serialize(record)
    [record.token]
  end

  def deserialize(keys)
    params = OAUTH.clone
    client = ::OAuth2::Client.new(params.delete(:client_secret), params.delete(:client_id), params)
    ::OAuth2::AccessToken.new(client, keys.first)
  end
end

Warden::OAuth2.user_finder(:dvdpost) do |user_id|
  Customer.find(user_id)
end
