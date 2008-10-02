module CategorySidebarHelper
    def self.get_context(option = {})
       Category.find(:all,:conditions => "user_id=#{option[:user_id]}")
     end
     def self.get_edit_context(options = {})
      {}
    end
end
