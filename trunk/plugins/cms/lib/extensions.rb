require 'mush/extensions'
include Mush::Extensions

require 'admin/admin_helper'
include AdminHelper

# params is extension_point, class, method
add_extension('mush_admin_add_mainmenu', AdminHelper, 'add_mainmenu')
add_extension('mush_admin_add_submenu', AdminHelper, 'add_submenu')
