map.connect 'admin/links/:action', :controller => 'admin/links'
map.resources :links, :path_prefix => '/admin', :controller => 'admin/links'

map.connect 'admin/tags/:action', :controller => 'admin/tags'
map.resources :tags, :path_prefix => '/admin', :controller => 'admin/tags'

map.connect 'admin/article_categories/:action', :controller => 'admin/article_categories'
map.resources :article_categories, :path_prefix => '/admin', :controller => 'admin/article_categories'

map.connect 'admin/blogs/:action', :controller => 'admin/blogs'
map.resources :blogs, :path_prefix => '/admin', :controller => 'admin/blogs'
