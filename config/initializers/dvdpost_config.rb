require 'dvdpost_constants' # Require here so we do not have to do it in the code
DVDPostConfig = HashWithIndifferentAccess.new.merge(YAML.load_file("#{RAILS_ROOT}/config/dvdpost_config.yml").symbolize_keys)
