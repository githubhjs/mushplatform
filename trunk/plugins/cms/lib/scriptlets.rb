# require 'app/helper/scriptlet_helper'

module Mush
  module Plugin
    class CmsScriptlet < Mush::Plugin::Scriptlet
      
      class << self
        def init
          add_scriptlet('article_list_by_all', :list_article)
          add_scriptlet('article_list_by_tag', :list_article_by_tag)
        end
      end
    end
  end
end
