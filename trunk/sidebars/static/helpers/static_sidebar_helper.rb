module StaticSidebarHelper
  
  def self.get_context(options = {})
    sidebar = SidebarUser.find(options[:id])
    settings(sidebar)
  end

  def self.get_edit_context(options = {})
    #sidebar = SidebarUser.find(:first,:conditions => {:user_id => options[:user_id],:sidebar_id => 'friend_link', :id => options[:id]})
    sidebar = SidebarUser.find(options[:id])
    settings(sidebar)
  end
  
  def self.settings(sidebar)
    settings = sidebar.settings||{}
    settings['id'] = sidebar.id
    settings['sidebar_id'] = sidebar.sidebar_id
    settings['content'] = settings['content'] || ""
    settings['header'] = settings['header'] || ""
    settings    
  end

end
