class UserProfile < ActiveRecord::Base
  
  belongs_to :user

  Company_Nature_Other      =  3
  Company_Nature_User       =  2
  Company_Nature_Suppliers  =  1

  validates_length_of :city,:minimum => 1,:too_short => "请填写您所在的城市"
  validates_length_of :sex,:minimum => 1,:too_short => "选选择性别"
  
end
