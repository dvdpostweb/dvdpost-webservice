ActionController::Routing::Routes.draw do |map|
  map.root :controller => :products, :action => :index # Temporary, should be a homepage action instead

  # Only the Clearance routes we actually need
  # Clearance::Routes.draw(map) # => If all Clearance routes are needed
  map.with_options :controller => 'clearance/sessions' do |clearance|
    clearance.resource :session,    :only   => [:new, :create, :destroy]
    clearance.sign_in  'sign_in',   :action => :new
    clearance.sign_out 'sign_out',  :action => :destroy, :method => :delete
  end

  map.resources :products, :only => [:index, :show]
end
