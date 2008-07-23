class Group < CachedModel

  include CachedExtend
  
  validates_uniqueness_of :group_name
  validates_presence_of :group_name
  
  after_save :after_save_update_cache
  
  Cached_All_Groups_Key = "activerecord_cached_all_groups"
  Cached_Role_Groups_Key = "activerecord_cached_role_groups"
  Status_Valid,Status_Invalid = 0,1
 
  
  #this method should be called, and reutrn self's roels
  def roles
    Role.group_roles_from_cache(self)
  end
  
  #contain inherint_group's roles
  def own_and_inherint_roles
    self.inherit_group.nil? ? self.roles : (self.roles+self.inherit_group.groups)
  end
  
  def update_own_roles_cache
    Role.update_special_group_roles_cache(self)
  end
  
  #this method should find from cache
  def self.all_groups
    cached_groups = Cache.get(Cached_All_Groups_Key)
    unless cached_groups
      find(:all,:conditions => "status=#{Status_Valid}")
      Cache.put(Cached_All_Groups_Key,cached_groups)
    end
    cached_groups    
  end
  
  def self.role_groups_from_db(role)
    Group.find_by_sql("select g.* from groups g inner join group_roles gr on (g.id=gr.group_id and gr.role_id=#{role.id})")
  end
  
  
  
  #find a sepecail group's roles
  def self.role_groups_from_cache(role)
    r_groups = Cache.get(generate_role_groups_key(role.id))
    unless r_groups
      r_groups = role_groups_from_db(role)
      Cache.put(generate_role_groups_key(role.id),r_groups)
    end
    r_groups
  end
  
  def self.generate_role_groups_key(r_id)
    "#{Cached_Role_Groups_Key}_of_#{r_id}"
  end
  
  def users
    User.group_users(self)
  end
  
  def self.user_groups(user)
    Group.find_by_sql("select g.* from groups g inner join group_users gu on (g.id=gu.group_id and gu.user_id=#{user.id})")
  end
  
  def after_save_update_cache
    update_all_groups_cache
    update_role_groups_cache
    Cache.put("active_record:Group:#{self.id}",self)
  end
  
  def update_all_groups_cache
    Cache.delete(Cached_All_Groups_Key)
    Cache.put(Cached_All_Groups_Key,Group.find(:all,:conditions => "status=#{Status_Valid}"))
  end
  
  def update_role_groups_cache
    self.roles.each do |role|
      Cache.delete(Group.generate_role_groups_key(role.id))
      Cache.put(Group.generate_role_groups_key(role.id),role.groups)
    end
  end
  
  #inherit group from cache
  def inherit_group
    self.inherit_group_id.blank? || self.inherit_group_id <= 0 ? nil : Group.find(self.inherit_group_id)
  end
  
  def self.update_special_role_groups_cache(role)
    unless role.nil?
      Cache.delete(Group.generate_role_groups_key(role.id))
      Cache.put(Group.generate_role_groups_key(role.id),role.groups)
    end
  end
  
  #this method should find from cache
  def self.find_by_group_name(g_name)
    find(:first,:conditions=>"group_name=#{g_name}")
  end
  
  def should_inherit_groups
    self.new_record? ? Group.all_groups :  Group.find(:all,:conditions => "status=#{Status_Valid} and id<> #{self.id}")
  end
  
  def inherit_from
    (self.inherit_group_id.blank? || self.inherit_group_id <= 0) ? nil : Group.find(self.inherit_group_id)
  end
  
end