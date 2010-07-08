OAUTH = HashWithIndifferentAccess.new.merge(YAML.load_file("#{RAILS_ROOT}/config/oauth.yml")[RAILS_ENV].symbolize_keys)
