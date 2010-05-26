module Warden
  module OAuth2

    def self.user_finder(key, &block)
      Strategy.user_finders[key] = block
    end

    def self.clear_user_finders
      Strategy.user_finders.clear
    end

  end
end
