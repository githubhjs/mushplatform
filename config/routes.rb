ActionController::Routing::Routes.draw do |map|
  
       
  #  map.resources :friends
  map.connect   "/user/select",:controller => 'user',:action => 'select'
  map.connect   "/user/signup",:controller => 'user',:action => 'signup'
  map.connect   "/user/login",:controller => 'user',:action => 'login'
  map.connect   "/user/login_bar",:controller => 'user',:action => 'login_bar'
  map.connect   "/user/logout",:controller => 'user',:action => 'logout'
#  map.connect   "/manage",:controller => 'manage/blogs',:action => 'index'
  map.connect   "/manage/common/select_with_ajax",:controller => "manage/common",:action => "select_with_ajax"
  map.connect   "/front/editors/upload_editor_image",:controller => 'front/editors',:action => "upload_editor_image"
  map.connect   "/front/editors/upload_editor_attach",:controller => 'front/editors',:action => "upload_editor_attach"
  
  
  map.with_options :controller => "my_space",:conditions => { :subdomain => /^(?!www$)\w+/ } do  |my_space|
    my_space.connect "/" ,:action => 'index'
    my_space.connect "/page/:page" ,:action => 'index'
    my_space.connect '/archive/:year/:month/:date',:action => 'index',
      :requirement => {:year => /(?:19|20|)\d\d/,:month =>/[01]?\d/,:date => /[0-3]\d/ }
    my_space.connect '/archive/:year/:month',:action => 'index',
      :requirement => {:year => /(?:19|20|)\d\d/,:month =>/[01]?\d/ }
    my_space.connect '/archive/:year/:month/page/:page',:action => 'index',
      :requirement => {:year => /(?:19|20|)\d\d/,:month =>/[01]?\d/ }
    my_space.connect '/articles/:year/:month/:date/page/:page',:action => 'index',
      :requirement => {:year => /(?:19|20|)\d\d/,:month =>/[01]?\d/,:date => /[0-3]\d/ }
    my_space.connect '/category/:category_id',:action => 'index'
    my_space.connect '/category/:category_id/page/:page',:action => 'index'
    my_space.connect '/tag/:tag',:action => 'index'
    my_space.connect '/tag/:tag/page/:page',:action => 'index'
    my_space.connect '/entry/:id',:action => 'show'
    my_space.connect '/entry/:id/comments',:action => 'show'
    my_space.connect '/entry/:id/comments/page/:page',:action => 'show'
    my_space.connect '/entry/:id/comments/create',:action => 'create_comment'
    my_space.connect '/photos',:action => 'photos'
    my_space.connect '/photos/page/:page',:action => 'photos'
    my_space.connect '/photos/:id',:action => 'photo'
    my_space.connect '/rss',:action => 'rss'
    my_space.connect '/blogs',:action => 'blogs'
    my_space.connect '/blogs/category/:category_id',:action => 'blogs'
    my_space.connect '/messages',:action => 'messages'
    my_space.connect '/friends',:action => 'friends'
    my_space.connect '/votes',:action => 'votes'
    my_space.connect '/votes/:id',:action => 'vote'
    my_space.connect '/groups',:action => 'groups'
    my_space.connect '/search',:action => 'search'
    my_space.connect '/profile',:action => 'profile'
  end
  
  map.with_options :controller => "manage/themes" do |theme|
    theme.connect      "/manage/themes",        :action => 'index'
    theme.connect    "/manage/themes/preview",:action => "preview"
    theme.connect    "/manage/themes/switchto",:action => "switchto"
  end
  map.connect "/manage",:controller => "manage/manage",:action => 'index'
  map.namespace :manage do |manage|
    manage.resources :blog_configs
    manage.resources :photos,:collection => {:friend_photos => :get,:ajax_create_alubm => :get}
    manage.resources :categories,:collection => {:ajax_new => :get},:member => {:delete => :get,:ajax_update => :get}
    manage.resources :comments
    manage.resources :sidebars,:member => {:active => :get,:remove => :get,:lower => :get,:higher => :get}
    manage.resources :messages,:member => { :delete => :get }
    manage.resources :blogs,:member => {:delete => :get,:sticky => :get},
                     :collection => {:drafts => :get,:batch_publish => :post,:search => :post}
    manage.resources :user_profiles
    manage.resources :user_groups,:member => {:new_topic => :get,:join => :get,:quit => :get,:create_topic => :post},
                     :collection => {:all => :get,:search => :post,:friend_groups => :get,:friend_create_groups => :get}
    manage.resources :topic_comments
    manage.resources :group_members
    manage.resources :topics,:member => {:comments => :post}
    manage.resources :friends, :collection => {:search => :any,:visitores => :get,:receiv_invites => :get,:send_invites => :get},
      :member => {:invite => :get,:cancle_invite => :get,:accept => :get}
    manage.resources :gifts, :collection => {:send_for => :get, :receive => :get, :send_to => :post,:send_gifts => :get,:gift_list => :get}
    manage.resources :votes,:collection => {:friend_votes => :get,:random_votes => :get},:member => {:post_vote => :post}
    manage.resources :regards,:collection => {:send_for => :get, :receive => :get, :send_to => :post,:send_regards => :get}
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
