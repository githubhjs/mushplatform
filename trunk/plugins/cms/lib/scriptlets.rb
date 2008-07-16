require 'mush/scriptlets'
include Mush::Scriptlets

require 'items_helper'
include ItemsHelper

Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.dirname(__FILE__) + "/../app/views")

add_scriptlet( :name => 'article_list_by_all', :function => :list_article, :template => 'articles', :template_type => 'fs')
add_scriptlet( :name => 'article_list_by_tag', :function => :list_article)
