class UserProfile < ActiveRecord::Base
  
  belongs_to :user
  Company_Nature_Other      =  3
  Company_Nature_User       =  2
  Company_Nature_Suppliers  =  1
end
