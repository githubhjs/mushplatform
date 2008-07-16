require 'mush/extensions'
include Mush::Extensions

require 'admin/admin_helper'
include AdminHelper

# params is extension_point, class, method
add_extension('mush_admin_add_more_menu', AdminHelper, 'add_menu_to_bar')
