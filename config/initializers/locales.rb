# Custom backend written in lib/
# I18n.backend = I18n::Backend::Custom.new

# Load locales from RAILS_ROOT/locales directory into Rails
I18n.default_locale = :fr

# Get loaded locales conveniently
# See http://rails-i18n.org/wiki/pages/i18n-available_locales
module I18n
  class << self
    def available_locales; backend.available_locales; end
  end
  module Backend
    class Simple
      def available_locales; [:fr, :en, :nl]; end
    end
  end
end

# You STILL need to do this hack, so <tt>I18n.available_locales</tt> actually returns something?
I18n.backend.send(:init_translations)

AVAILABLE_LOCALES = I18n.backend.available_locales
RAILS_DEFAULT_LOGGER.debug "* Loaded locales: #{AVAILABLE_LOCALES.inspect}"
