module LatestCommentsSidebarHelper

  Default_Laest_Comments_Count = 10
  
  def self.get_context(option = {})
    Comment.latest_comments(option[:user_id]).find(:all,:limit => Default_Laest_Comments_Count)
  end
    
end
