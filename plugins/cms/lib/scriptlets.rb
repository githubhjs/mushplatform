require 'mush/scriptlet/scriptlets'
include Mush::Plugin::Scriptlets

require 'items_helper'
include ItemsHelper
  
add_scriptlet('article_list_by_all', self, :list_article, articles)
add_scriptlet('article_list_by_tag', self, :list_article)
