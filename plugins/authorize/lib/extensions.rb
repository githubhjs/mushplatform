require 'mush/extension_points'
include Mush::ExtensionPoints
require 'admin/auth_helper'
include Admin::AuthHelper

# params is extension_point, class, method
add_extension('MushAdmin::AddMainmenu', Admin::AuthHelper, 'add_mainmenu')

#add_extension('mush_admin_add_submenu', AdminHelper, 'add_submenu')
