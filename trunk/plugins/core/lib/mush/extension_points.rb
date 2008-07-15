module Mush
  
  class ExtensionPoints
    class << self
      #generate extention point id
      #extention_pont_id = self.name + extention_method_name
      def generate_extension_point_id(extention_method_name)
        "#{self.name}.#{extention_method_name}"
      end 
      
      def execute_extension(extension_method_name)
        raise "Should be implemented"
      end
    end
  end

end