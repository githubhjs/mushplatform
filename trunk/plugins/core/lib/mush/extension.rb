#extension interface 
module Mush
  class Extension

    #function have three tpe:String or Proc or Method
    attr_accessor :point, :function, :priority

    def initialize(&init_block)
      instance_eval(&init_block) unless init_block.blank?
    end

    #to execute function
    def execute(params)
      case function
      when String
        eval(function)
      when Proc
        params ? function.call(params) : function.call
      when Method
        params ? function.call(params) : function.call
      else
        raise "Invalid extension type"
      end
    end

  end 
end
