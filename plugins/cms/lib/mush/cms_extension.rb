require 'extend_menuvar_demo'
require 'menubar'
module Cms
  module Plugin
    class CmsExtension < Mush::Plugin::Extension
      class << self
        def init
          regiester_for_extention(Menubar::Plugin::MenubarExtention.add_more_menu)    
        end
          
      end
    end 
  end
end
