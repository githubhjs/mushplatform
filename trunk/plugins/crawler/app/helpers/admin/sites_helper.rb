require 'util/date_util'
module Admin::SitesHelper
  
  def display_status(site)
    case site.status
    when Site::Site_Status_Enable then "enable"
    when Site::Site_Status_Disable then "disable"
    else ""
    end
  end

  def display_state(site)
    case site.state
    when Site::Site_State_Running then "running"
    when Site::Site_State_Wait then "wait"
    when Site::Site_State_Timeout then "timeout"
    when Site::Site_State_Failed then "failed"
    else ""
    end
  end
 
  def display_site_operation(site)
    operations = []
    case site.state
    when Site::Site_State_Running
      operations <<  "<a href='/admin/sites/#{site.id}/stop'>Stop</a>"
    when Site::Site_State_Wait,Site::Site_State_Timeout,Site::Site_State_Failed
      operations << "<a href='/admin/sites/#{site.id}/run'>Run</a>"
    end
    case site.status
    when Site::Site_Status_Enable 
      operations <<  "<a href='/admin/sites/#{site.id}/disable'>Disable</a>"
    when Site::Site_Status_Disable 
      operations << "<a href='/admin/sites/#{site.id}/enable'>Enable</a>"
    end
    operations.join('|')
  end
  
  def generate_status_options(selected = nil)
    options = [["Choose status/All", '-1'],[:enable, Site::Site_Status_Enable.to_s],[:disable, Site::Site_Status_Disable.to_s]]
    options_for_select(options, selected.to_s)
  end

  def generate_state_options(selected = nil)
    options = [["Choose state/All", '-1'],[:running, Site::Site_State_Running.to_s],
      [:wait, Site::Site_State_Wait.to_s],[:timeout, Site::Site_State_Timeout.to_s],[:failed, Site::Site_State_Failed.to_s]]
    options_for_select(options, selected.to_s)
  end

  def generate_is_craw_now_options(selected = nil)
    options = [["no", NO.to_s],["yes", YES.to_s]]
    options_for_select(options, selected.to_s)
  end
  
end