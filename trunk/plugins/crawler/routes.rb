map.namespace(:admin) do |admin|
  admin.resources :mush_crawlers
  admin.resources :crawler_sites,:member => {:stop => :get,:run => :get,:enable => :get,:disable => :get}
end