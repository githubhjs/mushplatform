require 'blog_helper'
Liquid::Template.register_filter(BlogHelper)

require 'blogengine'
require 'patches/controller_ex'
BlogEngine.init