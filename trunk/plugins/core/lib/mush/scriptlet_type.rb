module Mush
  
  class ScriptletType
    attr_accessor :name, :function

    def initialize(args = {})
      @name, @function = args['type_name'], args['function']
    end
    
  end

end
