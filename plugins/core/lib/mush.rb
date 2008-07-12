module Mush
  
  class << self
    
    require 'mush/plugin'
    def init
      
      # initialize plugin
      Mush::Plugin.init
                
    end
    
  end
  
end
