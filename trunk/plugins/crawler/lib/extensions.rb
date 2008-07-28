require 'mush/extension_points'
include Mush::ExtensionPoints

require 'admin/crawler_helper'
include CrawlerHelper

# params is extension_point, class, method
add_extension('MushAdmin::AddMainmenu', CrawlerHelper, 'add_crawlermenu',3)
