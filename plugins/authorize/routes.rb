map.namespace(:admin) do |admin|
  admin.resources :users,:member => {:authorize_user => :post}, :collection => {:search => :get}
  admin.resources :roles
  admin.resources :groups 
end