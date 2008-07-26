map.connect '/admin',:controller => 'mush_admin',:action => 'index'

map.connect 'admin/scriptlets/:action/:id', :controller => 'admin/scriptlets'
map.resources :scriptlets, :path_prefix => '/admin', :controller => 'admin/scriptlets'
