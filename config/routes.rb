ActionController::Routing::Routes.draw do |map|
 map.get_authentication 'authentication/api/Authenticate', :controller => :authentication, :action => :ok, :conditions => { :method => :get }
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => :gmail, :action => :index, :conditions => {:method => :get}
  
end
