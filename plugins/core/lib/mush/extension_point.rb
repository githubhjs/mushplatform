require 'mush/extension'

module Mush

  class ExtensionPoint
    attr_accessor :name, :extensions
    
    def initialize
      @extensions ||= []
    end
    
    def add_extension(extension)
      @extensions << extension
    end
    
    def do_extensions
      raise "Should be implement this by subclass"
    end
    
    def sort_by(extensions, attribute)
      extensions.sort {|x,y| x.send(attribute) <=> y.send(attribute) }
    end
    
  end

end