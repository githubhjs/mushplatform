require 'rexml/document'
require 'rexml/xpath'
require  File.dirname(__FILE__) + '/xml'
class XmlRequest
  
  Params_Name = :xml_params
  
 
  #   <request>
  #      <head>
  #       <method></method>
  #      </head>
  #      <params>
  #         <result>
  #           <keyword>sodeal</keyword>
  #         </result>
  #         <generalresulthistory>
  #           <keyword>retailmenot</keyword>
  #         </generalresulthistory>
  #      </params>
  #    </request>
  def initialize(xml_request)
    begin
      @xml_reqs = REXML::Document.new(xml_request)
    rescue Exception => e
      @xml_reqs = nil
    end
  end
  
  def valid?
    return !@xml_reqs.nil?
  end
  
  def results
   
    @results ||= unless @xml_reqs.nil?
      craw_results = []
      @xml_reqs.get_elements("/request/params/#{Result.name}").each do |xml_result|
        result = Xml.to_object(xml_result.to_s)
        craw_results << result unless result.nil?
      end
      craw_results
    else
      []
    end
       
    @results
  end
  
  def general_result_history
    
    @general_result_history ||= unless @xml_reqs.nil?
      xml_entry = @xml_reqs.get_elements("//params/#{GeneralResultHistory.name}").first
      Xml.to_object(xml_entry.to_s)
    else
      nil
    end
    @general_result_history
    
  end  
  
end
