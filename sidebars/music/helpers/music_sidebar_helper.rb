module MusicSidebarHelper

    def self.get_context(option = {})
      option[:user].blog_config.music      
    end

    def self.get_edit_context(options = {})
      {}
    end
    
end
