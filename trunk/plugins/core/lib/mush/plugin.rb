module Mush
  module Plugin
    @@scriptlets  = {}
    attr_accessor :extensions, :scriptlets
    class << self 
      # initialize all mush plugins,
      require 'mush/scriptlet'
      require File.dirname(__FILE__) + "/extension/extension"
      def init
      end
    end
  end
  
end
