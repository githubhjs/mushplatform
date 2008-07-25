class FetchURL
  public
  def self.url(url)
    host = url.scan(/\/\/(.*?)\//m)[0][0]
    path = url.split(/#{host}\//)[1]
    h = Net::HTTP.new(host,80)
    resp = h.get("/#{path}",nil)  
    
    if resp.message != "Not Found" 

#      p resp.message
#      p url
#      p resp['location']
      if resp.message == "OK"
        return url
      else
        return FetchURL.url(resp['location'])
      end
    end    
    return nil
  end
end