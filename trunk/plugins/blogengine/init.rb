require 'blog_helper'
Liquid::Template.register_filter(BlogHelper)

require 'blogengine'
require 'patches/controller_ex'
require 'patches/controller_extend'
BlogEngine.init