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
    
    def do_extensions(params)
      # default implemtation, subclass could overridenn this
      results = []
      begin
        @extensions = sort_by(extensions, :priority) if extensions.size > 1
        extensions.each {|extension| results << extension.execute(params)}
      rescue Exception => e
        #raise e.message
      end
      results.join(' ')
    end
    
    def sort_by(extensions, attribute)
      extensions.sort {|x,y| x.send(attribute) <=> y.send(attribute) }
    end
    
  end

end
