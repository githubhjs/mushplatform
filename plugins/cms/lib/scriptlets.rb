require 'mush/scriptlets'
include Mush::Scriptlets

require 'items_helper'
include ItemsHelper
  
add_scriptlet('article_list_by_all', :list_article, articles_template)
add_scriptlet('article_list_by_tag', :list_article)
