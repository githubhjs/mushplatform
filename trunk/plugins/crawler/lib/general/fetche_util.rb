require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'net/http'
require File.dirname(__FILE__) + '/http_client'

module FetchUtil
  
  #fetch html from remote server
  def fetch_html(uri)
    begin
      return Hpricot(get_response(uri))
    rescue Exception => e   
      return nil
    end
  end
 
  private
  def get_response(uri,headers={})
    response = HttpClient::get_response(uri,headers)
    return parse_response(response)
  end
  
  #parse response,return response.body or ""
  def parse_response(response)
    case response
    when Net::HTTPSuccess
      return response.body
    else
      return ""
    end
  end
  
end
