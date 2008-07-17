require 'mush/extension'
require 'mush/extension_points'

module MushAdmin
  class AddMainmenu < Mush::ExtensionPoint
    
    def initialize(name)
      super
    end
  
    def mush_admin_add_mainmenu
    end

    def do_extensions
      results = []
      begin
        extensions.each {|extension| results << extension.execute}
      rescue Exception => e
#          raise e.message
      end
      results.join(' ')
    end
  end
      
end
