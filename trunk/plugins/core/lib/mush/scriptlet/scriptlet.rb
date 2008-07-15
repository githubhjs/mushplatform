module Mush
  
  module Plugin
    
    class Scriptlet < Liquid::Variable
      
      def initialize(markup)
	super
      end
     
      def render(context)
        return '' if @name.nil?
        context[@name]
      end
      
    end
  
  end
  
end
