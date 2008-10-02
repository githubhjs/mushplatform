module PersonalItemSidebarHelper

  Default_Per_Page = 2

  def self.get_context(option = {})
    Message.find(:all,:conditions => {:user_id => option[:user_id]},:limit => Default_Per_Page)
  end
    
  def self.get_edit_context(option = {})
    {}
  end

end
