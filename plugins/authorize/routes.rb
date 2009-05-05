map.namespace(:admin) do |admin|
  admin.resources :users,:member => {:authorize_user => :post, :search => :post}
  admin.resources :roles
  admin.resources :groups 
end

