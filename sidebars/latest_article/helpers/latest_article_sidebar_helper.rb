module LatestArticleSidebarHelper
  
  Default_Latest_Article_Perpage = 10

  def self.get_context(option = {})
    Blog.find(:all,:conditions => "published = #{Blog::Published_Blogs} and user_id=#{option[:user_id]}",
    :order => "updated_at desc", :limte => Default_Latest_Article_Perpage)
  end

  def self.get_edit_context(options = {})
    {}
  end
  
end
