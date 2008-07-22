class Group < ActiveRecord::Base
  
  has_many :group_roles
  has_many :roles,:through => :group_roles
  has_many :group_users
  has_many :users,:through => :group_users  

  validates_uniqueness_of :group_name
  validates_presence_of :group_name
  
    
  Status_Valid,Status_Invalid = 0,1
  
  #this method should find from cache
  def self.all_groups
    find(:all,:conditions => "status=#{Status_Valid}")
  end
  
  #this method should find from cache
  def self.find_by_group_name(g_name)
    find(:first,:conditions=>"group_name=#{g_name}")
  end
  
  def should_inherit_groups
    self.new_record? ? Group.all_groups :  Group.find(:all,:conditions => "status=#{Status_Valid} and id<> #{self.id}")
  end
  
  def inherit_from
    (self.inherit_group.blank? || self.inherit_group <= 0) ? nil : Group.find_by_id(self.inherit_group)
  end
  
end