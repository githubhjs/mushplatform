require 'mush/extension_points'
include Mush::ExtensionPoints

require 'admin/mush_admin_helper'
include MushAdminHelper

# params is extension_point, class, method, priority
add_extension('MushAdmin::AddMainmenu', MushAdminHelper, 'add_mainmenu', 9)
