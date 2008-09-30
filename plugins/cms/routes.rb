#connect "", :controller => "cms"

#map.resources :channels
#map.admin 'admin/channels/:action', :controller => 'admin/channels'
map.connect 'admin/channels/:action', :controller => 'admin/channels'
map.resources :channels, :path_prefix => '/admin', :controller => 'admin/channels'

map.connect 'admin/templates/:action/:id', :controller => 'admin/templates'
map.resources :templates, :path_prefix => '/admin', :controller => 'admin/templates'

map.connect 'admin/assets/:action/:id', :controller => 'admin/assets'
map.resources :assets, :path_prefix => '/admin', :controller => 'admin/assets'

map.connect 'admin/articles/:action/:id', :controller => 'admin/articles'
#map.resources :articles, :path_prefix => '/admin', :controller => 'admin/articles'

map.dispatch '*path', :controller => 'site', :action => 'dispatch'
