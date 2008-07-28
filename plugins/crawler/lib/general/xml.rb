require 'rexml/document'
require 'rexml/xpath'
class Xml
    
  #return a Object from xml
  #  
  class << self
    
    def to_object(xml_entry)
      xml_object = begin
        REXML::Document.new(xml_entry)
      rescue Exception => e
        nil
      end
      return nil if xml_object.nil?
      begin
        klass = Object.const_get(xml_object.root.name.to_sym)
        unless klass.nil?
          entry = klass.new
          children = xml_object.root.get_elements('child::node()')        
          children.each do |node|
            method_id = node.name.gsub('-','_')
            entry.send("#{method_id}=",node.text) if entry.respond_to?("#{method_id}=".to_sym)
          end
          return entry
        end
      rescue Exception => e
        
      end
      return nil
    end 
    
  end
  
end
