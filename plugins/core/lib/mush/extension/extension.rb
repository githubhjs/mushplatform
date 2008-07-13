require File.dirname(__FILE__) + '/extender'
module Mush
  
  module Plugin
    class Extension
      class InvalidExtenderParam < StandardError
      end
      Default_Priority = 10
      @@extention_regestry = {}
      class << self
        
        def init
          
        end
        
        #register extender for a  specail extention point
        def regiester_for_extension(point_id,extender)
          @@extention_regestry[point_id] ||= []
          @@extention_regestry[point_id] << extender
        end
        
        #remove extender from a specail extention point
        def unregister_for_extension(point_id,extender=nil)         
          binders = @@extention_regestry[point_id]
          binders.delete(extender) if extender
        end
        
        def remove_all_extenders_of_extension(point_id)
          @@extention_regestry[point_id] = nil
        end
        
        #select all extenders of a special extention point
        def select_extention_extenders(pont_id)
          @@extention_regestry[pont_id]
        end
        
        #generate extention point id
        #extention_pont_id = self.name + extention_method_name
        def generate_extension_point_id(extention_method_name)
          "#{self.name}.#{extention_method_name}"
        end 
        require File.dirname(__FILE__) + "/extender"
        #arg extender_options have three type:
        #first type:Object,method_name ,priority=10(should pass tow params atleast)
        #second type:string ,priority=10(should pass one atleast)
        #third type:proc,priority=10(should pass one atleast)
        def generate_extender(*extender_options)
          first_param = extender_options.first
#          function,priority = begin
           function,priority =  case extender_options.size
              #if params is sting or proc
            when 1
              raise InvalidExtenderParam ,"Invalid extender params" unless first_param.is_a?(String) || first_param.is_a?(Proc)
              [first_param,Default_Priority]
              #if params are (Object,method_name) or (string,priority) or (proc,priority)
            when 2
              second_param = extender_options[1]
              #if params are (string,priority) or (proc,priority)
              if second_param.is_a?(Integer)
                [first_param,second_param]
                #if params are (Object,method_name)  
              elsif second_param.is_a?(String)
                [first_param.method(second_param.to_sym),Default_Priority]
              end
              # if params are (object,method_name,priority)  
            when 3
              third_param = extender_options[2]
              raise InvalidExtenderParam,"Invalid extender params" if third_param.is_a?(Integer)
              [first_param.method(extender_options[1].to_sym),third_param]
            end
#          rescue Exception => e
#            raise InvalidExtenderParam,"Invalid extender params"
#          end
          Extender.new do
            self.function = function
            self.priority = priority
          end
        end 
        
      end
           
    end
    
  end
    
end
