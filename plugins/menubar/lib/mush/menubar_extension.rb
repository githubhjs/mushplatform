module Menubar
  module Plugin
    class MenubarExtension < Mush::Plugin::Extension
  
      class << self
        def add_more_menu
            generate_extension_point_id('add_more_menu') 
        end
  
        def remove_menu
           remove_all_extenders_of_extension('remove_menu')   
        end
      end
  
    end 
  end
end

