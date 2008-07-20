#connect "", :controller => "cms"

#map.resources :channels
#map.admin 'admin/channels/:action', :controller => 'admin/channels'
map.connect 'admin/channels/:action', :controller => 'admin/channels'
map.connect 'admin/templates/:action', :controller => 'admin/templates'

map.dispatch '*path', :controller => 'cms', :action => 'dispatch'
