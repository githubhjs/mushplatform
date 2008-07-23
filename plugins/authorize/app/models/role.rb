class Role < CachedModel
 
  include CachedExtend
  
  validates_uniqueness_of :role_name
  validates_presence_of :role_name
  
  Cached_All_Roles_Key = "activerecord_cached_all_roles"
  Cached_Group_Roles_Key = "activerecord_cached_group_roles"
  
  Status_Valid,Status_Invalid = 0,1
  
  after_save :after_save_update_cache
  
  
  def groups
    Group.role_groups_from_cache(self)
  end
  
  def update_own_groups_cache
    Group.update_special_role_groups_cache(self)
  end
  
  #this method should find from cache
  def self.all_roles
    cached_roles = Cache.get(Cached_All_Roles_Key)
    unless cached_roles
      cached_roles = find(:all,:conditions => "status=#{Status_Valid}")
      Cache.put(Cached_All_Roles_Key,cached_roles)
    end
    cached_roles    
  end
  
  #find a sepecail group's roles
  def self.group_roles_from_cache(group)
    g_roles = Cache.get(generate_group_roles_key(group.id))
    unless g_roles
      g_roles = group_roles_from_db(group)
      Cache.put(generate_group_roles_key(group.id),g_roles)
    end
    g_roles
  end
  
  def self.group_roles_from_db(group)
    Role.find_by_sql("select r.* from roles r inner join group_roles gr on (r.id=gr.role_id and gr.group_id=#{group.id})") 
  end
  
  def self.generate_group_roles_key(g_id)
    "#{Cached_Group_Roles_Key}_of_#{g_id}"
  end
  
  def after_save_update_cache
    update_all_roles_cache
    update_group_roles_cache
  end
  
  def update_all_roles_cache
    Cache.delete(Cached_All_Roles_Key)
    Cache.put(Cached_All_Roles_Key,Role.find(:all,:conditions => "status=#{Status_Valid}"))
  end
  
  def update_group_roles_cache
    self.groups.each do |group|
      Cache.delete(Role.generate_group_roles_key(group.id))
      Cache.put(Role.generate_group_roles_key(group.id),group.roles)
    end
  end
  #cahce
  def self.update_special_group_roles_cache(group)
    unless group.nil?
      Cache.delete(Role.generate_group_roles_key(group.id))
      Cache.put(Role.generate_group_roles_key(group.id),group.roles)
    end
  end
  
  #this method should find from cache
  def self.find_by_role_name(r_name)
    find(:first,:conditions=>"role_name=#{r_name}")
  end
  
end
