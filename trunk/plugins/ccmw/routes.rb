map.connect 'admin/links/:action', :controller => 'admin/links'
map.resources :links, :path_prefix => '/admin', :controller => 'admin/links'

map.connect 'admin/tags/:action', :controller => 'admin/tags'
map.resources :tags, :path_prefix => '/admin', :controller => 'admin/tags'

map.connect 'admin/blogs/:action', :controller => 'admin/blogs'
map.resources :blogs, :path_prefix => '/admin', :controller => 'admin/blogs'

map.connect 'admin/blogs/:action', :controller => 'admin/blogs'
map.resources :blogs, :path_prefix => '/admin', :controller => 'admin/blogs'