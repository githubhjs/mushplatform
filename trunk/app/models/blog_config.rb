class BlogConfig < CachedModel

  include CachedExtend

  belongs_to :user

  after_save :reset_cache

  def self.add_view_count(user_id)
    BlogConfig.connection.execute("update blog_configs set view_count = view_count+1 where user_id=#{user_id}")
  end

  def reset_cache   
    Cache.put(BlogConfig.config_cacke_key(self.user_id),self,15)
  end

  def self.find_by_user_id(user_id)
    cache_key = config_cacke_key(user_id)
    config =  Cache.get(cache_key)
    unless config
      config = find(:first,:conditions => "user_id=#{user_id}")||create(:user_id => user_id)
      Cache.put(cache_key,config,15)
    end
    config
  end

  def self.config_cacke_key(user_id)
    "record_blog_config_uid#{user_id}"
  end

  
end
