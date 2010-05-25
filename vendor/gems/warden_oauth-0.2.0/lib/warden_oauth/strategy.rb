module Warden
  module OAuth2

    #
    # Holds all the main logic of the OAuth authentication, all the generated
    # OAuth classes will extend from this class
    #
    class Strategy < Warden::Strategies::Base
      extend StrategyBuilder

      ######################
      ### Strategy Logic ###
      ######################


      def self.access_token_user_finders
        (@_user_token_finders ||= {})
      end

      #
      # An OAuth strategy will be valid to execute if:
      # * A 'warden_oauth_provider' parameter is given, with the name of the OAuth service
      # * A 'oauth_token' is being receive on the request (response from an OAuth provider)
      #
      def valid?
        (params.include?('warden_oauth_provider') && params['warden_oauth_provider'] == config.provider_name.to_s) ||
                params.include?('oauth_token')
      end

      #
      # Manages the OAuth authentication process, there can be 3 outcomes from this Strategy:
      # 1. The OAuth credentials are invalid and the FailureApp is called
      # 2. The OAuth credentials are valid, but there is no user associated to them. In this case
      #    the FailureApp is called, but the env['warden.options'][:oauth][:access_token] will be 
      #    available.
      # 3. The OAuth credentials are valid, and the user is authenticated successfuly
      #
      # @note
      # If you want to signup users with the twitter credentials, you can manage the creation of a new 
      # user in the FailureApp with the given access_token
      #
      def authenticate!
        if params.include?('warden_oauth_provider')
          store_request_class_on_session
          redirect!(client.authorize_url)
          throw(:warden)
        elsif params.include?('oauth_token') and session[:request_class] == self.class.to_s
          store_token_on_session
          user = find_user_by_access_token(access_token)
          if user.nil?
            fail!("User with access token not found")
            throw_error_with_oauth_info
          elsif !token_validated?
            fail!("OAuth token invalid")
            throw_error_with_oauth_info
          else
            success!(user)
          end
        end
      end

      def fail!(msg) #:nodoc:
        self.errors.add(service_param_name.to_sym, msg)
        super
      end

      ###################
      ### OAuth Logic ###
      ###################

      def client
        @client ||= ::OAuth2::Client.new(config.app_id, config.app_secret, config.options)
      end

      def access_token
        @access_token ||= ::OAuth2::AccessToken.new(client, session_oauth_token)
      end

      def session_oauth_token
        session[:oauth_token]
      end

      protected

      def find_user_by_access_token(access_token)
        raise RuntimeError.new(<<-ERROR_MESSAGE) unless self.respond_to?(:_find_user_by_access_token)
        
You need to define a finder by access_token for this strategy.
Write on the warden initializer the following code:
Warden::OAuth.access_token_user_finder(:   #{config.provider_name}   ) do |access_token|
  # Logic to get your user from an access_token
end

        ERROR_MESSAGE
        self._find_user_by_access_token(access_token)
      end

      def throw_error_with_oauth_info
        throw(:warden, :oauth => {
                self.config.provider_name => {
                        :provider     => config.provider_name,
                        :access_token => access_token,
                        :app_id       => config.app_id,
                        :app_secret   => config.app_secret
                }
        })
      end

      def store_request_class_on_session
        session[:request_class]  = self.class.to_s
      end

      def store_token_on_session
        session[:request_class]  = self.class.to_s
        session[:oauth_token]  = params['oauth_token']
      end

      def token_validated?
        begin
          access_token.get('/oauth/authorize')
          true
        rescue OAuth2::AccessDenied => e
          false
        end
      end

      def missing_stored_token?
        !session_oauth_token
      end

      def service_param_name
        '%s_oauth' % config.provider_name
      end

      def config
        self.class::CONFIG
      end

    end

  end
end
