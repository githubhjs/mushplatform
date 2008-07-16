module Mush
  
  class ExtensionPoints
    class << self
      def execute_extension(extension_method_name)
        raise "Should be implemented"
      end
    end
  end

end