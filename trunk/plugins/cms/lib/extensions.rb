require 'mush_admin'
require 'admin/admin_helper'

module Cms
  class CmsExtension < Mush::Extension
    class << self
      def init
        #register ExtendMenubarDemo for MenubarExtension.add_more_menu
        extender = generate_extender(ExtendMenubarDemo,'add_menu_to_bar')
        regiester_for_extension(MushAdmin::MushAdminExtension.add_more_menu,extender)    
      end
          
    end
  end  
end

