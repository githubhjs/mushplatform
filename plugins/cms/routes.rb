#connect "", :controller => "cms"

#map.resources :channels
#map.admin 'admin/channels/:action', :controller => 'admin/channels'
map.connect 'admin/channels/:action', :controller => 'admin/channels'
map.connect 'admin/templates/:action/:id', :controller => 'admin/templates'
map.connect 'admin/assets/:action/:id', :controller => 'admin/assets'

map.dispatch '*path', :controller => 'cms', :action => 'dispatch'
