#extender interface 
module Mush
  module Plugin
    class Extender
      
      #function have three tpe:String or Proc or Method
      attr_accessor :priority,:function
      
      def initialize(&init_block)
        instance_eval(&init_block)   unless init_block.blank?
      end
      
      #to execute function
      def execute
        case function
        when String
          eval(function)
        when Proc
          function.call
        when Method
          action.call
        else
          raise "Invalid extender type"
        end
      end
      
    end 
  end
end