require 'net/http'
require 'uri'
require File.dirname(__FILE__)+'/multipart'
module HttpClient  
  class << self
 
    def post_form(target_path,params)
      target_url ||= URI.parse(target_path) 
      mp ||= Multipart::MultipartPost.new 
      query, headers = mp.prepare_query(params)
      begin
        return post_to_remote_server(target_url,query,headers)
      rescue Exception => e       
        return nil
      end
    end 
  
    def post_to_remote_server(url, query, headers)
      response = Net::HTTP.start(url.host, url.port)   do |http|
        #http.read_timeout = TIMEOUT_SECONDS
        http.post(url.path, query, headers)
      end
      return response
    end 
    
    def get_response(url,headers={})
      get_url = URI.parse(url)  
      req = Net::HTTP::Get.new("#{get_url.path}?#{get_url.query}",headers.merge({"User-Agent" =>"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)"}))
      begin
        response =  Net::HTTP.start(get_url.host, get_url.port) {|http|
          http.request(req)
        }
        return response
      rescue Exception => e        
        return nil
      end
    end
    
  end
  
end
