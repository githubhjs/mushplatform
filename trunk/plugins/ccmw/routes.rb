map.connect 'admin/links/:action', :controller => 'admin/links'
map.connect 'admin/links/page/:page', :controller => 'admin/links', :action => 'index'
map.resources :links, :path_prefix => '/admin', :controller => 'admin/links'

map.connect 'admin/tags/:action', :controller => 'admin/tags'
map.connect 'admin/tags/page/:page', :controller => 'admin/tags', :action => 'index'
map.resources :tags, :path_prefix => '/admin', :controller => 'admin/tags'

map.connect 'admin/article_categories/:action', :controller => 'admin/article_categories'
map.connect 'admin/article_categories/page/:page', :controller => 'admin/article_categories', :action => 'index'
map.resources :article_categories, :path_prefix => '/admin', :controller => 'admin/article_categories'

map.connect 'admin/blogs/:action', :controller => 'admin/blogs'
map.connect 'admin/blogs/page/:page', :controller => 'admin/blogs', :action => 'index'
map.resources :blogs, :path_prefix => '/admin', :controller => 'admin/blogs'

map.connect 'admin/blocks/:action', :controller => 'admin/blocks'
map.resources :blocks, :path_prefix => '/admin', :controller => 'admin/blocks'
