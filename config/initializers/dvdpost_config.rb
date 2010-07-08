DVDPostConfig = HashWithIndifferentAccess.new.merge(YAML.load_file("#{RAILS_ROOT}/config/dvdpost_config.yml").symbolize_keys)
