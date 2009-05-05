map.namespace(:admin) do |admin|
  admin.resources :users,:member => {:authorize_user => :post, :search => :get}
  admin.resources :roles
  admin.resources :groups 
end

