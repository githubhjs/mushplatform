module Mush
  
  class ScriptletType
    attr_accessor :name, :function

    def initialize(args = {})
      @name, @function = args.delete(:name), args.delete(:function)
    end

  end

end
