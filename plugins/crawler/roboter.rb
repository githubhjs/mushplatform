class Roboter
  
  attr_accessor :craw_site
  def initialize(craw_site)
    @craw_site = craw_site
  end
  
  def run
    
    begin
      if craw_site
        require File.dirname(__FILE__) + "/lib/crawlers/#{craw_site.site_name}_crawler"
        crawler_klass = Object.const_get("#{craw_site.site_name.capitalize}Crawler".to_sym)
        if crawler_klass
          craw_site.set_run
          crawler_klass.new.fetch
          craw_site.set_finish
        end
      end
    rescue Exception => e
      raise "No crawler for #{craw_site.site_name}"
    end
    
  end
  
end

while true
  sites = Site.ready_to_craw_sites
  sites.each do |site|
    puts "to fetch #{site.site_name}"
    fork do
      roboter = Roboter.new(site)
      roboter.run
    end
    sleep(10)
  end
  sleep(1*60)
end