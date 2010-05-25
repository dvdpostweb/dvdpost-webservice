require File.dirname(__FILE__) + "/../spec_helper"
require "rack/test"

describe Warden::OAuth2::Strategy do  
  def fixture_response(name)
    filename = File.dirname(__FILE__) + "/../fixtures/%s.txt" % name
  end

  describe '.build' do
    before(:each) do
      @config = Warden::OAuth2::Config.new
      @config.app_id "ABC"
      @config.app_secret "123"
      @config.options :site => 'http://service.com'
      Warden::OAuth2::Strategy.send(:remove_const, "Service") if Warden::OAuth2::Strategy.const_defined?("Service")
      Warden::Strategies.clear!
      Warden::OAuth2::Strategy.build(:service, @config)
    end

    it "should create a new instance that extends from Warden::OAuth2::Strategy" do
      Warden::OAuth2::Strategy.const_defined?("Service").should be_true
      (Warden::OAuth2::Strategy::Service < Warden::OAuth2::Strategy).should be_true
    end

    it "should register the oauth service key on the Warden strategies with `_oauth` appended" do
      Warden::Strategies[:service_oauth].should_not be_nil
      Warden::OAuth2::Strategy::Service.should_not be_nil
      Warden::Strategies[:service_oauth].should == Warden::OAuth2::Strategy::Service
    end

    it "should assign the oauth_service config as a constant" do
      Warden::OAuth2::Strategy::Service::CONFIG.should_not be_nil
      Warden::OAuth2::Strategy::Service::CONFIG.should == @config 
    end

  end

  describe "when invoking the strategy" do
    
    before(:each) do
      @request  = Rack::MockRequest.new($app)
    end


    describe "without warden_oauth_service nor oauth_token parameter" do
      
      before(:each) do
        @response = @request.get("/")
      end

      it "should render the failure app response" do
        @response.body.should == "You are not authenticated"
      end

    end

    describe "with a warden_oauth_provider parameter" do

      before(:each) do
        @response = @request.get("/", :params => { 'warden_oauth_provider' => 'example' })
      end 

      it "should redirect to the authorize url" do
        # It seems warden has changed behaviour and redirects to a path instead of URL
        # matcher was originally "http://localhost:3000/oauth/authorize"
        @response.headers['Location'].should =~ %r"/oauth/authorize"
      end

    end

    describe "when receiving a valid oauth response" do
      include Rack::Test::Methods
      
      def app
        $app
      end

      before(:each) do
        Warden::Strategies.clear!
        Warden::OAuth2::Strategy.send(:remove_const, "Example") if Warden::OAuth2::Strategy.const_defined?("Example")
      end

      describe "and the access_token_user_finder hasn't been declared" do

        before(:each) do
          FakeWeb.register_uri(:post, 'http://localhost:3000/oauth/request_token', 
                               :body => fixture_response("unauthorized_request_token"))
        end

        it "should raise an exception saying that the access_token_finder is not declared" do
          get "/", 'warden_oauth_provider' => 'example'
          FakeWeb.register_uri(:post, 'http://localhost:3000/oauth/access_token', 
                               :body => 'oauth_token=ABC&oauth_token_secret=123')
          lambda do
            @response = get "/", 'oauth_token' => "SylltB94pocC6hex8kr9",
                     'oauth_verifier' => "omPxEkKnnx9ygnu7dd6f"
          end.should raise_error(RuntimeError, /strategy/)
        end

      end
      
      describe "and the access_token_user_finder has been declared" do

        before(:each) do
          Warden::OAuth2.access_token_user_finder(:example) do |access_token|
            Object.new if access_token.token == 'SylltB94pocC6hex8kr9'
          end
          FakeWeb.register_uri(:post, 'http://localhost:3000/oauth/authorize',
                               :head => 200)
          get "/", 'warden_oauth_provider' => 'example'
        end

        after(:each) do
          Warden::OAuth2.clear_access_token_user_finders
        end

        describe "and the user is not found" do

          before(:each) do
            get "/",
                'oauth_token' => "WrongToken",
                'oauth_verifier' => "omPxEkKnnx9ygnu7dd6f"
          end

          it "should invoke the fail app" do
            last_response.body.should ==  "No user with the given access token"
          end

        end

        describe "and the user is found" do

          before(:each) do
            FakeWeb.register_uri(:get, 'http://localhost:3000/oauth/authorize?access_token=SylltB94pocC6hex8kr9',
                                 :status => ['200', 'Welcome'],
                                 :body => 'Welcome')
            get "/",
                'oauth_token' => "SylltB94pocC6hex8kr9",
                'oauth_verifier' => "omPxEkKnnx9ygnu7dd6f"
          end

          it "should go to the desired app" do
            last_response.body.should == "Welcome" 
          end

        end
      end

    end

  end

end
