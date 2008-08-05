require 'util/url_util'
class Site < ActiveRecord::Base
  
  validates_uniqueness_of :site_name

  has_many :craw_jobs,:foreign_key => 'site_id'

  before_create :set_last_finish_time_before_create
  
  Site_State_Wait    = 0
  Site_State_Running = 1
  Site_State_Timeout = 2
  Site_State_Failed  = 3
  
  Site_Status_Enable = 0
  Site_Status_Disable = 1
  
  NO = 0
  YES = 1
  
  def before_create_by_business
    self.last_finish_time = Time.now - self.craw_freq
    File.delete(crawler_name) if File.exist?(crawler_name)
  end
  
  def crawler_script=(form_script)
    unless form_script.blank?
      file = File.new(crawler_name, 'w') do |f|
        file.write(form_script.read) 
      end
    end
  end  
  
  def crawler_name
    File.dirname(__FILE__) + "/../../lib/crawlers/#{self.site_name.downcase}_crawler.rb"
  end
  
  def before_create_by_business
    self.state = Site_State_Wait
    self.status = Site_Status_Enable
    self.craw_now = NO
  end
  
  def set_run
    self.state = Site_State_Running
    save
  end
  
  def set_finish
    self.state = Site_State_Wait 
    self.last_finish_time = Time.now
    save
  end
  
  def self.ready_to_craw_sites
    find(:all,:conditions => "status = #{Site_Status_Enable} and state <> #{Site_State_Running} and (craw_now=1 or date_add(last_finish_time,Interval craw_freq second) < now())")
  end
  
  def self.one_ready_to_craw_sites
    find(:first,:conditions => "status = #{Site_Status_Enable} and state <> #{Site_State_Running} and (craw_now=1 or date_add(last_finish_time,Interval craw_freq second) < now())")
  end
  
  def before_save_by_business
    self.site_url = UrlUtil::format_url(self.site_url)
  end

  def modify
    return true
  end

  def enable
    self.status = Site_Status_Enable
    return save
  end

  def disable
    self.status = Site_Status_Disable
    return save
  end

  
  def run
    self.state = Site_State_Running 
    self.craw_now = YES
    save 
  end
  
  def stop
    self.state = Site_State_Wait
    save
    CrawJob.stop(self.id)
  end

  def stop_process_attributes
    self.state = Site_State_Failed
    self.last_finish_time = Time.now()
  end
  
  def finish_process_attributes
    self.state = Site_State_Wait
    self.last_finish_time = Time.now()
  end
  
  def timeout_process_attributes
    self.state = Site_State_Timeout
    self.last_finish_time = Time.now()
  end
  
  def cancel_craw
    self.craw_now = NO
    return save 
  end
  
  def craw
    self.craw_now = YES
    return save
  end
  
  def is_craw_now?
    return self.craw_now == YES
  end
  
  def is_running?
    return self.state  == Site_State_Running
  end
  
  def is_enable?
    self.status == Site_Status_Enable
  end
  
  def timeout?
    self.state == Site_State_Timeout
  end
  
end