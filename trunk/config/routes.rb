ActionController::Routing::Routes.draw do |map|
  
  #  map.resources :friends
  map.resources :signup, :collection => {:select => :get}
  map.connect   "/login",:controller => 'login',:action => 'login'
  map.connect   "/sign_up",:controller => 'login',:action => 'sign_up'
  map.connect   "/logout",:controller => 'login',:action => 'logout'
  map.connect   "/manage",:controller => 'manage/manage',:action => 'index'
  map.connect   "/manage/common/select_with_ajax",:controller => "manage/common",:action => "select_with_ajax"
  
  map.with_options :controller => "my_space",:conditions => { :subdomain => /^(?!www$)\w+/ } do  |my_space|
    my_space.connect "/" ,:action => 'index'
  end
  
  map.with_options :controller => "manage/themes" do |theme|
    theme.connect      "/manage/themes",        :action => 'index'
    theme.connect    "/manage/themes/preview",:action => "preview"
    theme.connect    "/manage/themes/switchto",:action => "switchto"
  end
  
  map.namespace :manage do |manage|
    manage.resources :categories,:collection => {:ajax_new => :get},:member => {:delete => :get,:ajax_update => :get}
    manage.resources :comments
    manage.resources :sidebars,:member => {:active => :get,:remove => :get,:lower => :get,:higher => :get}
    manage.resources :messages,:member => { :delete => :get }
    manage.resources :blogs,:member => {:delete => :get,:sticky => :get},
      :collection => {:drafts => :get,:batch_publish => :post}
    manage.resources :user_profiles
  end


  #map.resources :roles

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  map.from_plugin :crawler
  map.from_plugin :mush_admin
  map.from_plugin :authorize
  map.from_plugin :ccmw
  map.from_plugin :cms
    
  # Install the default routes as the lowest priority.
  #  map.connect ':controller/:action/:id'
  #  map.connect ':controller/:action/:id.:format'
end
