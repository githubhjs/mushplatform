require 'mush/scriptlets'
include Mush::Scriptlets

require 'cms_helper'
include CmsHelper

Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.dirname(__FILE__) + "/../app/views")

add_scriptlet_type('type_name' => 'list_articles', 'function' => :list_articles)
add_scriptlet('name' => 'list_article_by_channel', 'type_name' => 'list_articles', 'template' => 'articles', 'template_type' => 'fs')
