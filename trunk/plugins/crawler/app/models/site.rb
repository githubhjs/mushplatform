require 'util/url_util'
class Site < ActiveRecord::Base

  has_many :craw_jobs,:foreign_key => 'site_id'

  Site_State_Wait    = 0
  Site_State_Running = 1
  Site_State_Timeout = 2
  Site_State_Failed  = 3
  
  Site_Status_Enable = 0
  Site_Status_Disable = 1
  
  NO = 0
  YES = 1
  
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
    find(:all,:conditions => "status = #{Site_Status_Enable} and state <> #{Site_State_Running} and date_add(last_finish_time,Interval craw_freq second) < now()")
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

  def stop
    job = get_running_job
    if (job)
      job.stop
    end
  end

  def get_running_job
    CrawJob.find(:first,:conditions => {:site_id => self.id ,:status => Craw_Job_Status_Running}) 
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