map.namespace(:admin) do |admin|
  admin.resources :users
  admin.resources :roles
  admin.resources :groups 
end

