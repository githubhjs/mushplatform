class Scriptlet < ActiveRecord::Base #< Liquid::Variable
  attr_accessor :params

  def scriptlet_type
    @@scriptlet_types_registry[type_name]
  end
  
  def type_is_fs?
    return true if template_type == 'fs'
    false
  end
  
  def tmplt
    if template_type == 'fs'
      tmplt = Liquid::Template.file_system.read_template_file(template) 
    else
      tmplt = template
    end
    tmplt
  end

  def render(context)
    return '' if scriptlet_type.name.nil?
    begin
      # params is passed by scriplet string in template,
      # and page is passed by cms_controller, combined 
      # with all params.  
      # Scriptlet method will use the params to invoke.
      params[:page] = context['page']
      
      # every scriptlet function should be return a hash 
      # which include the parameters for template using
      vars = params ? scriptlet_type.function.call(params) : scriptlet_type.function.call
    rescue Exception => e
      return "Scriptlet #{scriptlet_type.name} error : #{e}"
    end
    if template_type == 'fs'
      tmplt = Liquid::Template.file_system.read_template_file(template) 
    else
      tmplt = template
    end
    if tmplt
      Liquid::Template.parse(tmplt).render vars 
    else
      vars.to_s
    end
  end

end
