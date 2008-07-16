module Mush
  
  class Scriptlet #< Liquid::Variable
    attr_accessor :name, :function, :template

    def initialize(name, function, template = nil)
      @name, @function, @template = name, function, template
    end

    def render(context)
      return '' if @name.nil?
#      vars = instance.send function if instance.respond_to?(function)
      begin
        vars = function.call
      rescue
        return 'Scriptlet error'
      end
      if template
        Liquid::Template.parse(template).render vars 
      else
        vars.to_s
      end
    end

  end
  
end