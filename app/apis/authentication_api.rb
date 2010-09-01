class AuthenticationApi < ActionWebService::API::Base
  inflect_names false
  api_method :Authenticate,
             :expects => [{:strAccount    => :string},
                          {:strToken      => :string},
                          {:strReferrer   => :string},
                          {:strSourceURL  => :string},
                          {:strClientIP   => :string}],
             :returns => [{:Result        => :int}]
end
