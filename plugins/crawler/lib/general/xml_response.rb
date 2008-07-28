require 'rexml/document'
class XmlResponse
  
  Success_Code,Failure_Code = '1','0'
  
  Xml_Response_Format = <<xml
   <response>
      <head>
         <result-code></result-code>
      </head> 
      <content>
      </content>
   </response>
xml
  
  class << self
        
    def create_response(if_succe,objects = [])
      xml_response = REXML::Document.new(Xml_Response_Format)
      r_code = if_succe ? Success_Code : Failure_Code
      result_code = xml_response.get_elements('//head/result-code').first
      result_code.text= r_code
      unless objects.nil? || objects.empty?
        content = xml_response.get_elements('/response/content').first
        objects.each do |obj|
          content.add(REXML::Document.new(obj.to_xml)) unless obj.nil?
        end
      end
      return xml_response.to_s.gsub("<?xml version='1.0' encoding='UTF-8'?>",'')
    end
        
  end
  
end
