module Mush
  
  class Scriptlet < ActiveRecord::Base #< Liquid::Variable
    attr_accessor :params

    def scriptlet_type
      @@scriptlet_types_registry[scriptlet_type_name]
    end
    
    def render(context)
      return '' if scriptlet_type.name.nil?
      begin
        # every scriptlet function should be return a hash 
        # which include the parameters for template using
        vars = params ? scriptlet_type.function.call(params) : scriptlet_type.function.call
      rescue
        return "Scriptlet #{scriptlet_type.name} error"
      end
      tmplt = Liquid::Template.file_system.read_template_file(template) if template_type == 'fs'
      if tmplt
        Liquid::Template.parse(tmplt).render vars 
      else
        vars.to_s
      end
    end

  end
  
end