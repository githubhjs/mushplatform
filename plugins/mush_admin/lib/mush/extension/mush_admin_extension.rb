module MushAdmin
  class MushAdminExtension < Mush::Extension
  
    class << self
    
      def add_more_menu
        generate_extension_point_id('add_more_menu') 
      end
  
      def remove_menu
        remove_all_extenders_of_extension('remove_menu')   
      end
      
      def execute_extension(point_id)
        extension_results = []
        extenders = select_extenders(point_id)
        begin
          extenders.each {|extender| extension_results << extender.execute}
        rescue Exception => e
#          raise e.message
        end
        extension_results.join(' ')
      end
      
    end
  
  end
 
end
