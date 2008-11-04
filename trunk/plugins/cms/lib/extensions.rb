require 'mush/extension_points'
include Mush::ExtensionPoints

require 'admin/admin_helper'
include AdminHelper

# params is extension_point, class, method
add_extension('MushAdmin::AddMainmenu', AdminHelper, 'add_mainmenu_cms', 1)
add_extension('MushAdmin::AddMainmenu', AdminHelper, 'add_mainmenu_articles', 2)
