module Mush
  
  module Plugin
    @@extensions  = []
    @@scriptlets  = {}
    attr_accessor :extensions, :scriptlets
    
    class << self 
      
      # initialize all mush plugins,
      def init
        
        puts "initialize all plugins"
        
        # find all mush plugins
        # get plugin directory
        # require needed files
        # do what ever should do
               
        # other processes
        
      end
    end
    
  end
  
end
