require 'mush/scriptlets'
include Mush::Scriptlets

require 'cms_helper'
include CmsHelper

Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.dirname(__FILE__) + "/../app/views")

add_scriptlet_type('type_name' => 'article_list', 'function' => :list_article)
add_scriptlet('name' => 'article_list_by_all', 'type_name' => 'article_list', 'template' => 'articles', 'template_type' => 'fs')
