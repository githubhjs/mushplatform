# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
require 'rexml/document'
module Xml
  
  def to_xml
    xml_entry = REXML::Document.new("<#{self.class.name}></#{self.class.name}>")
    self.instance_variables.each do |variable|
      value = self.instance_variable_get(variable.to_sym)
      xml_entry.root.add_element(variable.gsub('@','').gsub('_','-')).add_text(value.to_s)
    end
    return xml_entry.to_s
  end
  
  
end
