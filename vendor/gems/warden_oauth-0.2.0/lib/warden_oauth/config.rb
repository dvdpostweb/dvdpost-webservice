module Warden
  module OAuth2
  
    #
    # Holds all the information of the OAuth service.
    #
    class Config
      attr_accessor :provider_name
      
      def app_id(app_id = nil)
        unless app_id.nil?
          @app_id = app_id
        end
        @app_id
      end
      alias_method :app_id=, :app_id

      def app_secret(secret = nil)
        unless secret.nil?
          @app_secret = secret
        end
        @app_secret
      end
      alias_method :app_secret=, :app_secret

      def options(options = nil) 
        unless options.nil?
          @options = options
        end
        @options
      end
      alias_method :options=, :options

      def check_requirements
        if @app_id.nil? || @app_secret.nil?
          raise Warden::OAuth2::ConfigError.new("You need to specify the app id and the app secret")
        end
      end

    end

  end
end
