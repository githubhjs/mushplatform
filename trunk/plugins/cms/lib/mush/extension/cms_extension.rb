require 'mush_admin'
require File.dirname(__FILE__) +'/extend_menubar_demo'
module Cms
  class CmsExtension < Mush::Plugin::Extension
    class << self
      def init
        #register ExtendMenubarDemo for MenubarExtension.add_more_menu
        extender = generate_extender(ExtendMenubarDemo,'add_menu_to_bar')
        regiester_for_extension(MushAdmin::MushAdminExtension.add_more_menu,extender)    
      end
          
    end
  end  
end

