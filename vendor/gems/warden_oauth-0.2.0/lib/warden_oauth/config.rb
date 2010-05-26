module Warden
  module OAuth2
    #
    # Holds all the information of the OAuth service.
    #
    class Config
      attr_accessor :provider_name
      
      def client_id(client_id = nil)
        unless client_id.nil?
          @client_id = client_id
        end
        @client_id
      end
      alias_method :client_id=, :client_id

      def client_secret(secret = nil)
        unless secret.nil?
          @client_secret = secret
        end
        @client_secret
      end
      alias_method :client_secret=, :client_secret

      def options(options = nil) 
        unless options.nil?
          @options = options
        end
        @options
      end
      alias_method :options=, :options

      def check_requirements
        if @client_id.nil? || @client_secret.nil?
          raise Warden::OAuth2::ConfigError.new("You need to specify the app id and the app secret")
        end
      end

    end

  end
end
