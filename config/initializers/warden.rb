Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.oauth(:dvdpost) do |sso_dvdpost|
    sso_dvdpost.app_secret = OAUTH[:app_secret]
    sso_dvdpost.app_id     = OAUTH[:app_id]
    sso_dvdpost.options :site => OAUTH[:site]
  end
  manager.default_strategies(:dvdpost_oauth)
  manager.failure_app = OauthController
end

# Setup Session Serialization
class Warden::SessionSerializer
  def serialize(record)
    [record.class, record.id]
  end

  def deserialize(keys)
    klass, id = keys
    klass.find(:first, :conditions => {:id => id})
  end
end