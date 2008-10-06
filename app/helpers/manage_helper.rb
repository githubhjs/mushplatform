module ManageHelper

  def display_sidebar_setting_info(user_id,sidebar_id)
    sidebar = Sidebar.find(SidebarUser.find(sidebar_id).sidebar_id)
    sidebar ? sidebar.get_edit_page({:user_id => user_id,:id => sidebar_id}) : ""
  end
  
end
