module BlogHelper
    
  def entry_permalink(entry)
    link_to entry['title'], "/entry/#{entry['id']}", :title => entry['title']
  end

  def display_sidebar(user)
    sidebar_infos = SidebarUsers.user_sidebars.map{|bar|
      Sidebar.find(bar.sidebar_id)}.compact.map{|sidebar|sidebar.get_content(sidebar_options())}
    sidebar_infos.join('   ')
  end

  private
  
  
end
