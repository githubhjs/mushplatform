module Mush
  
  module Plugin
    
    class Extension
      
      class << self
        
        def add_extension(point, function, priority = 10)
          puts "add extension #{name}:#{function}"
  #        idx = build_unique_id(point, function, priority)
  #        Mush::Plugin.extensions[point][priority][idx] = ['function' => function]
        end

        # TODO
        def remove_extension(point, function, priority = 10)
        end

        # TODO
        def has_extension?(point, function_to_check = false)
        end

        private

        def build_unique_id(point, function, priority)
        end
        
      end

    end
    
  end
    
end