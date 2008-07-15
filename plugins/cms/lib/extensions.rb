require 'admin/admin_helper'
require 'mush_admin/extension_points'

module Cms
  class CmsExtension < Mush::Extension

    class << self
      def init
        #register ExtendMenubarDemo for MenubarExtension.add_more_menu
        extender = generate_extender(ExtendMenubarDemo,'add_menu_to_bar')
        regiester_for_extension(MushAdmin::ExtensionPoints.add_more_menu,extender)    
      end
          
    end
  end  
end

