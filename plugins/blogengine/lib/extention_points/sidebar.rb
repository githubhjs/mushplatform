require 'mush/extension'
require 'mush/extension_points'
module MushAdmin
  class Sidebar < Mush::ExtensionPoint
    def do_extensions
      results = []
      begin
        @extensions = sort_by(extensions, :priority) if extensions.size > 1
        extensions.each {|extension| results << extension.execute}
      rescue Exception => e
        #raise e.message
      end
      results.join(' ')
    end
  end
      
end
