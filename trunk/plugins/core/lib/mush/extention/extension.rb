module Mush
  
  module Plugin
    
    class Extension
      @@extention_regestry = {}
      class << self
        
        #register for a  specail extention point
        def regiester_for_extention(point_id,extender)
          @@extention_regestry[point_id] ||= []
          @@extention_regestry[point_id] << extender
        end
        
        #remove extender from a specail extention point
        def unregister_for_extention(point_id,extender)        
          binders = @@extention_regestry[point_id]
          binders.delete(extender) if extender
        end
        
        #select all extenders of a special extention point
        def select_extention_extenders(pont_id)
          @@extention_regestry[pont_id]
        end
        
        def generate_extention_pont_id(extention_name)
          "#{self.name}.#{extention_name}"
        end 
        
        def generate_extender(render_options)
          raise  "#{args.size} for 2  args at least"
          if args.size == 1
            
          end
        end 
        
      end
     
      
    end
    
  end
    
end