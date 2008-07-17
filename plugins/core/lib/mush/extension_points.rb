require 'mush/extension'

module Mush
  
  module ExtensionPoints

    @@extension_points_registry = {}
    Default_Priority = 10

    #add extension for a  specail extention point
    def add_extension(point, *extension_options)
      extension_point =  @@extension_points_registry[point]
      unless extension_point
        klass = point.scan(/^(.*)::(.*)$/)[0][1]
        file = klass.scan(/^([A-Z][a-z]*)(.*)$/)[0].collect{|s| s.downcase}.join('_')
        require "extension_points/#{file}"
#        klass = Object.const_get(point)
        klass = point.split("::").inject(Object) {|x,y| x.const_get(y)}
        extension_point = klass.new(point)
        @@extension_points_registry[point] = extension_point
      end
      extension = generate_extension(*extension_options)
      extension_point.add_extension(extension)
    end

    #select all extensions of a special extension point
    def select_extension_point(point)
      @@extension_points_registry[point]
    end

    def remove_extension_point(point)
      @@extension_points_registry.delete(point)
    end

    def do_extensions(point)
      extension_point = @@extension_points_registry[point]
      extension_point.do_extensions if extension_point
    end
    
    #arg extension_options have three type:
    #first type:Object,method_name ,priority=10(should pass tow params atleast)
    #second type:string ,priority=10(should pass one atleast)
    #third type:proc,priority=10(should pass one atleast)
    def generate_extension(*extension_options)
      first_param = extension_options.first
      #          function,priority = begin
      function,priority =  case extension_options.size
        #if params is sting or proc
      when 1
        raise InvalidExtensionParam ,"Invalid extension params" unless first_param.is_a?(String) || first_param.is_a?(Proc)
        [first_param,Default_Priority]
        #if params are (Object,method_name) or (string,priority) or (proc,priority)
      when 2
        second_param = extension_options[1]
        #if params are (string,priority) or (proc,priority)
        if second_param.is_a?(Integer)
          [first_param,second_param]
          #if params are (Object,method_name)  
        elsif second_param.is_a?(String)
          [first_param.method(second_param.to_sym),Default_Priority]
        end
        # if params are (object,method_name,priority)  
      when 3
        third_param = extension_options[2]
        raise InvalidExtensionParam,"Invalid extension params" if third_param.is_a?(Integer)
        [first_param.method(extension_options[1].to_sym),third_param]
      end
      #          rescue Exception => e
      #            raise InvalidextensionParam,"Invalid extension params"
      #          end
      extension = Extension.new do
        self.function = function
        self.priority = priority
      end 
      extension
    end
    
    def require_file(klass_name)
    end

    class InvalidExtensionParam < StandardError
    end
    
  end

end