module TagListSidebarHelper

    def self.get_context(option = {})
      Blog.tag_counts
    end

    def self.get_edit_context(options = {})
      {}
    end

end
