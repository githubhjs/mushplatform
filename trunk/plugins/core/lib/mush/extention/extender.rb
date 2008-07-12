module Mush
  module Plugin
    class Extender
      
      attr_accessor :priority,:function
      
      def initialize(&init_block)
        instance_eval(&init_block)   unless init_block.blank?
      end
      
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