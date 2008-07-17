require 'mush/extension'

module Mush
  
  class ExtensionPoints
    class << self
      def execute_extension(extension_method_name)
        raise "Should be implemented"
      end
    end
  end
  
  module ExtensionPoint
    def do_extension(point)
      extension_results = []
      extensions = Mush::Extension.select_extensions(point)
      begin
        extensions.each {|extension| extension_results << extension.execute}
      rescue Exception => e
#          raise e.message
      end
      extension_results.join(' ')      
    end
  end

end