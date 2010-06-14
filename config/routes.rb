ActionController::Routing::Routes.draw do |map|
  map.root :locale => :fr, :controller => :home, :action => :index, :conditions => {:method => :get}

  map.resources :locales, :except => [:show], :member => {:reload => :post} do |locale|
    locale.resources :translations, :except => [:show], :member => {:update_in_place => :post}
  end

  map.with_options :path_prefix => '/:locale' do |localized|
    localized.root :controller => :home, :action => :index, :conditions => {:method => :get}

    localized.oauth_authenticate 'oauth/authenticate', :controller => :oauth, :action => :authenticate, :conditions => {:method => :get}
    localized.oauth_callback     'oauth/callback',     :controller => :oauth, :action => :callback,     :conditions => {:method => :get}
    localized.logout             'logout',             :controller => :oauth, :action => :logout,       :conditions => {:method => :get}

    localized.with_options :controller => :home do |home|
      home.indicator_closed 'home/indicator_closed', :action => :indicator_closed, :conditions => {:method => :get}
      home.news 'home/news', :action => :news, :conditions => {:method => :get}
    end

    localized.resources :products, :only => [:index, :show] do |product|
      product.resource :rating, :only => :create
      product.resources :wishlist_items, :only => [:new, :create]
      product.resources :reviews, :only => [:new, :create]
      product.uninterested 'uninterested', :controller => :products, :action => :uninterested
      product.seen 'seen', :controller => :products, :action => :seen
      product.awards 'awards', :controller => :products, :action => :awards
    end

    localized.resources :categories, :only => [] do |category|
      category.resources :products, :only => :index
    end
    localized.resources :actors, :only => [] do |actor|
      actor.resources :products, :only => :index
    end
    localized.resources :directors, :only => [] do |director|
      director.resources :products, :only => :index
    end

    localized.resources :tops, :only => [] do |top|
      top.resources :products, :only => :index
    end

    localized.resources :themes, :only => [] do |theme|
      theme.resources :products, :only => :index
    end

    localized.resources :reviews, :only => [] do |review|
      review.resource :review_rating, :only => :create
    end

    localized.resources :wishlist_items, :only => [:new, :create, :update, :destroy]
    localized.wishlist 'wishlist', :controller => :wishlist_items, :action => :index, :conditions => {:method => :get}

    localized.resources :messages
    localized.resources :phone_requests, :only => [:new, :create]

    localized.faq 'faq', :controller => :messages, :action => :faq

    localized.resources :orders, :only => [] do |orders|
      orders.resource :report, :only => [:new, :create]
    end

    localized.resources :partners

    localized.resources :customers, :only => [:show] do |customer|
      customer.newsletter 'newsletter', :controller => :customers, :action => :newsletter, :only => [:update]
      customer.rotation_dvd 'rotation_dvd', :controller => :customers, :action => :rotation_dvd, :only => [:update]
    end
  end
end
