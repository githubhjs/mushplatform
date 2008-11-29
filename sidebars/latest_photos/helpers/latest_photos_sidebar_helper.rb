module LatestPhotosSidebarHelper
  Default_Laest_Photos_Count = 4
    def self.get_context(option = {})
      Photo.latest_photos(option[:user_id]).find(:all,:limit => Default_Laest_Photos_Count)
    end
    def self.get_edit_context(options = {})
      {}
    end
end
