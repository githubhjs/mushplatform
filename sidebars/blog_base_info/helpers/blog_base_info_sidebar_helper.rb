module BlogBaseInfoSidebarHelper

    def self.get_context(option = {})
      values = {}
      values['blogs_count'] = Blog.count('id', :conditions => "user_id = #{option[:user_id]}")
      values['comments_count'] = Comment.count('id', :conditions => "blog_user_id = #{option[:user_id]}")
      blog_config = BlogConfig.find_by_user_id(option[:user_id])
      if blog_config
        values['hits_count'] = blog_config.view_count
      else
        values['hits_count'] = Blog.sum('view_count', :conditions => "user_id = #{option[:user_id]}")
      end
      values['created_at'] = User.find(option[:user_id]).created_at
      values
    end

    def self.get_edit_context(options = {})
      {}
    end

end
