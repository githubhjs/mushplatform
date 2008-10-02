module ManageHelper

  def display_sidebar_setting_info(user_id,sidebar_id)
    sidebar = Sidebar.find(sidebar_id)
    sidebar ? sidebar.get_edit_page({:user_id => user_id}) : ""
  end
  
end
