require 'general/xml_request'
require 'general/xml_response'
class Admin::CrawlerClientController < ActionController::Base
  
  #select a configuraton 
  #and send to crawler
  
  Const_NO,Const_YES = 0,1
  
  def generate_configuration
    
    config = Configuration.find(:first,
      :conditions =>"be_searching = #{Const_NO} and date_add(last_search_time,Interval 60*search_freq second) < now()")
   
    xml = unless config.nil? ||(keywords = config.keywords).empty?||(sites=config.sites).empty?      
      config.update_attributes(:be_searching => Const_YES)
      XmlResponse.create_response(true,keywords+sites << config)
    else
      XmlResponse.create_response(false)     
    end
    
    render :xml =>  xml
    
  end
  
  
  #after searching
  #this action will be called to update result,and create GeneralHistoryResult
  def create_result
    
    
    render :xml => XmlResponse.create_response(true)
    
  end
  
  #after  finishing to search a configuration
  #this action will be called to update configuration's status
  def finish
    
    xml_param = params[XmlRequest::Params_Name]
    
    xml_request = XmlRequest.new(xml_param)
    
    if xml_request.valid?
      result = xml_request.results.first
      if result && Configuration.update(result.configuration_id,{:be_searching => Const_NO,:last_search_time => Time.now})
        render :xml => XmlResponse.create_response(true)
        return true
      end
    end
    
    render :xml => XmlResponse.create_response(false)
    
  end  
  
end
