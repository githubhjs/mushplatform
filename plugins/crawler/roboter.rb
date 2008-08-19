require File.dirname(__FILE__) + '/../../config/environment'
require File.dirname(__FILE__) + '/lib/general/craw_logger'
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
          puts "to featch #{craw_site.site_url}"
          CrawLogger.logger("to featch #{craw_site.site_url}")
          craw_site.set_run
          crawler_klass.new(craw_site).fetch
          craw_site.set_finish
        else
          CrawLogger.logger("None crawler for #{craw_site.site_name}")
        end
      end
    rescue Exception => e
      CrawLogger.logger(e.message)
    end
    
  end
  
end

while true
  site = Site.one_ready_to_craw_sites
  unless site.blank?
    CrawJob.delete_all("site_id=#{site.id}")
    CrawJob.create(:site_id => site.id,:crawler_pid => Process.pid)
    begin
      puts "get a job to fetch: #{site.site_name}"
      CrawLogger.logger("get a job to fetch: #{site.site_name}")
      roboter = Roboter.new(site)
      roboter.run
      sleep(10) 
    rescue Exception => e
      CrawLogger.logger(e.message)
    end
  end
  sleep(1*60)
end