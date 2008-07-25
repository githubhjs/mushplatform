map.namespace(:admin) do |admin|
  admin.resources :users,:member => {:authorize_user => :post}
  admin.resources :roles
  admin.resources :groups 
end

