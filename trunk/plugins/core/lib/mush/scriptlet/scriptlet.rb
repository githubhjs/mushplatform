require File.dirname(__FILE__) + '../template/variable'

module Mush
  
  module Plugin
    
    class Scriptlet < Mush::Template::Variable
      
      def initialize(markup)
        super(markup)
      end
      
    end
  
  end
  
end
