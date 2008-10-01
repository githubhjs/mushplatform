require 'mush/extension_points'
include Mush::ExtensionPoints

require 'ccmw_helper'
include CcmwHelper

# params is extension_point, class, method
add_extension('MushAdmin::AddMainmenu', CcmwHelper, 'add_mainmenu', 2)

add_extension('MushAdmin::AddArticleExtraAttributes', CcmwHelper, 'add_article_extra_attributes', 1)
