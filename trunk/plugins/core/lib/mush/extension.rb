#extension interface 
module Mush
  class Extension

    #function have three tpe:String or Proc or Method
    attr_accessor :point, :function, :priority

    def initialize(&init_block)
      instance_eval(&init_block) unless init_block.blank?
    end

    #to execute function
    def execute
      case function
      when String
        eval(function)
      when Proc
        function.call
      when Method
        function.call
      else
        raise "Invalid extension type"
      end
    end

  end 
end