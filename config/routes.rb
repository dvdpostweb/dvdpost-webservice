ActionController::Routing::Routes.draw do |map|
  map.root :locale => :fr, :controller => :products, :action => :index, :conditions => {:method => :get} # Temporary, should be a homepage action instead

  map.with_options :path_prefix => '/:locale' do |localized|
    # Only the Clearance routes we actually need
    # Clearance::Routes.draw(map) # => If all Clearance routes are needed
    localized.with_options :controller => 'clearance/sessions' do |clearance|
      clearance.resource :session,    :only   => [:new, :create, :destroy]
      clearance.sign_in  'sign_in',   :action => :new, :conditions => {:method => :get}
      clearance.sign_out 'sign_out',  :action => :destroy, :conditions => {:method => :get}
    end

    localized.with_options :controller => 'home' do |home|
      home.indicator_closed 'home/indicator_closed', :action => :indicator_closed, :conditions => {:method => :get}
    end

    localized.resources :products, :only => [:index, :show] do |product|
      product.resource :rating, :only => :create
      product.resources :wishlist_items, :only => [:new, :create]
      product.uninterested 'uninterested', :controller => :products, :action => :uninterested
      product.seen 'seen', :controller => :products, :action => :seen
      product.awards 'awards', :controller => :products, :action => :awards
    end
    localized.resources :reviews do |review|
      review.resource :review_rating, :only=> :create
    end

    localized.resources :wishlist_items, :only => [:new, :create, :update, :destroy]
    localized.wishlist 'wishlist', :controller => :wishlist_items, :action => :index, :conditions => {:method => :get}
  end
end
