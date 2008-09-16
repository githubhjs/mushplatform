class Category < ActiveRecord::Base
  
  validates_uniqueness_of  :name,:message => "类别名已被占用"
  
  validates_length_of       :name, :in => 1..80,:too_short => "名字不能为空",:too_long => "名子不能长于80"
  

end
