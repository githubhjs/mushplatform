require 'mush/extension'

module MushAdmin
  class ExtensionPoints < Mush::ExtensionPoints
  
    class << self
    
      def mush_admin_add_more_menu
      end
  
      def mush_admin_remove_menuend
        
      end
      
      def execute_extension(point_id)
        extension_results = []
        extensions = Mush::Extension.select_extensions(point_id)
        begin
          extensions.each {|extension| extension_results << extension.execute}
        rescue Exception => e
#          raise e.message
        end
        extension_results.join(' ')
      end
      
    end
  
  end
 
end
