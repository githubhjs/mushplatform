module Mush
  module Plugin
    @@scriptlets  = {}
    attr_accessor :extensions, :scriptlets
    class << self 
      # initialize all mush plugins,
      require 'mush/scriptlet'
      require File.dirname(__FILE__) + "/scriptlet/scriptlet_view_helper"
      require File.dirname(__FILE__) + "/extension/extension"
      def init
        ActionView::Base.class_eval { include Mush::Plugin::ScriptletViewHelper }
      end
    end
  end
  
end
