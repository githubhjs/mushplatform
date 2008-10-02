module FriendLinkSidebarHelper
  
  def self.get_context(options = {})
    sidebar = SidebarUser.find(:first,:conditions => {:user_id => options[:user_id],:sidebar_id => 'friend_link'})
    sidebar.settings['content']
  end

  def self.get_edit_context(options = {})
    sidebar = SidebarUser.find(:first,:conditions => {:user_id => options[:user_id],:sidebar_id => 'friend_link'})
    {'content' => sidebar.settings['content']}
  end

end
