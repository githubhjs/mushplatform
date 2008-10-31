require 'mush/scriptlets'
include Mush::Scriptlets

require 'blog_helper'
include BlogHelper

add_scriptlet_type('type_name' => 'list_blog_entries', 'function' => :list_blog_entries)