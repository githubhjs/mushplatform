module Mush
  
  class Scriptlet #< Liquid::Variable
    attr_accessor :name, :function, :template, :params

    def initialize(args = {})
      @name, @function, @template, = args.delete(:name), args.delete(:function), args.delete(:template)
      template_type = args.delete(:template_type)
      case template_type
      when 'fs'
        @template = Liquid::Template.file_system.read_template_file(template)
      when 'db'
      when 'mem'
      else  
      end
    end

    def render(context)
      return '' if name.nil?
#      vars = instance.send function if instance.respond_to?(function)
      begin
        vars = params ? function.call(params) : function.call
      rescue
        return "Scriptlet #{name} error"
      end
      if template
        Liquid::Template.parse(template).render vars 
      else
        vars.to_s
      end
    end

  end
  
end