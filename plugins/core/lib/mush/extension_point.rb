require 'mush/extension'

module Mush

  class ExtensionPoint
    attr_accessor :name, :extensions
    
    def initialize(name)
      @name = name
      @extensions ||= []
    end
    
    def add_extension(extension)
      @extensions << extension
    end
    
    def do_extensions
      raise "Should be implement this by subclass"
    end
    
  end

end