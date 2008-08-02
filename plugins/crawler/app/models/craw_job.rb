class CrawJob < ActiveRecord::Base
  
  def self.stop(site_id)
    jobs = find(:all,:conditions =>"site_id=#{site_id}")
    jobs.each do |job|
      puts "stop process pid:#{job.crawler_pid}"
      begin
        Process.kill(-9, job.crawler_pid) 
      rescue Exception => e
      end
    end
    delete_all("site_id=#{site_id}")
  end  
  
end
