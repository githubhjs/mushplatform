class Role < ActiveRecord::Base
  
  has_many :group_roles
  has_many :groups,:through => :group_roles
  
  Status_Valid,Status_Invalid = 0,1
  
  #this method should find from cache
  def self.all_roles
    find(:all,:conditions => "status=#{Status_Valid}")
  end
  
  #this method should find from cache
  def self.find_by_role_name(r_name)
    find(:first,:conditions=>"role_name=#{r_name}")
  end
end
