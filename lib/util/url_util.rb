module UrlUtil
  class << self    
    def format_url(url)
      return url if url.blank?
      url.strip!
      return url if url =~ /^http:\/\// || url =~ /^https:\/\//
      return "http://#{url}"
    end
    
  end
  
end
