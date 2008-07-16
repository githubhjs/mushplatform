require 'mush/extensions'
include Mush::Extensions

require 'admin/admin_helper'
include AdminHelper

# params is extension_point, class, method
add_extension('add_more_menu', AdminHelper, 'add_menu_to_bar')

#register ExtendMenubarDemo for MenubarExtension.add_more_menu
#extender = generate_extender(ExtendMenubarDemo,'add_menu_to_bar')
#regiester_for_extension(MushAdmin::ExtensionPoints.add_more_menu,extender)
