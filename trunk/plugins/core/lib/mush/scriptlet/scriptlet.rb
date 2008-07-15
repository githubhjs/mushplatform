module Mush
  
  module Plugin
    
    class Scriptlet #< Liquid::Variable
      attr_accessor :name, :instance, :function, :template
      
      def initialize(name, instance, function, template = nil)
	@name, @instance, @function, @template = name, instance, function, template
      end
     
      def render(context)
        return '' if @name.nil?
        vars = instance.send function if instance.respond_to?(function)
        if template
          Liquid::Template.parse(template).render vars 
        else
          vars.to_s
        end
      end
      
    end
  
  end
  
end