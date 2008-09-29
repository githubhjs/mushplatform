require 'util/date_util'
module Admin::CrawlerSitesHelper
  
  def display_status(site)
    case site.status
    when CrawlerSite::Site_Status_Enable then "enable"
    when CrawlerSite::Site_Status_Disable then "disable"
    else ""
    end
  end

  def display_state(site)
    case site.state
    when CrawlerSite::Site_State_Running then "running"
    when CrawlerSite::Site_State_Wait then "wait"
    when CrawlerSite::Site_State_Timeout then "timeout"
    when CrawlerSite::Site_State_Failed then "failed"
    else ""
    end
  end
 
  def display_site_operation(site)
    operations = []
    case site.state
    when CrawlerSite::Site_State_Running
      operations <<  "<a href='/admin/crawler_sites/#{site.id}/stop'>Stop</a>"
    when CrawlerSite::Site_State_Wait,CrawlerSite::Site_State_Timeout,CrawlerSite::Site_State_Failed
      operations << "<a href='/admin/crawler_sites/#{site.id}/run'>Run</a>"
    end
    case site.status
    when CrawlerSite::Site_Status_Enable 
      operations <<  "<a href='/admin/crawler_sites/#{site.id}/disable'>Disable</a>"
    when CrawlerSite::Site_Status_Disable 
      operations << "<a href='/admin/crawler_sites/#{site.id}/enable'>Enable</a>"
    end
    operations.join('|')
  end
  
  def generate_status_options(selected = nil)
    options = [["Choose status/All", '-1'],[:enable, CrawlerSite::Site_Status_Enable.to_s],[:disable, CrawlerSite::Site_Status_Disable.to_s]]
    options_for_select(options, selected.to_s)
  end

  def generate_state_options(selected = nil)
    options = [["Choose state/All", '-1'],[:running, CrawlerSite::Site_State_Running.to_s],
      [:wait, CrawlerSite::Site_State_Wait.to_s],[:timeout, CrawlerSite::Site_State_Timeout.to_s],[:failed, CrawlerSite::Site_State_Failed.to_s]]
    options_for_select(options, selected.to_s)
  end

  def generate_is_craw_now_options(selected = nil)
    options = [["no", NO.to_s],["yes", YES.to_s]]
    options_for_select(options, selected.to_s)
  end
  
end