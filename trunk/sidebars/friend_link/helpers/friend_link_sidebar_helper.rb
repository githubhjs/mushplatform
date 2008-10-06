module FriendLinkSidebarHelper
  
  def self.get_context(options = {})
    sidebar = SidebarUser.find(:first,:conditions => {:user_id => options[:user_id],:sidebar_id => 'friend_link', :id => options[:id]})
    (sidebar.settings||{})['content'] || "暂时没有内容"
  end

  def self.get_edit_context(options = {})
    #sidebar = SidebarUser.find(:first,:conditions => {:user_id => options[:user_id],:sidebar_id => 'friend_link', :id => options[:id]})
    sidebar = SidebarUser.find(options[:id])
    {'content' => (sidebar.settings||{})['content']||'没有选项'}
  end

end
