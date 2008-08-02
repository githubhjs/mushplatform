map.namespace(:admin) do |admin|
  admin.resources :mush_crawlers
  admin.resources :sites,:member => {:stop => :get,:run => :get,:enable => :get,:disable => :get}
end