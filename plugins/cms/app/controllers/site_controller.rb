class SiteController < ApplicationController
  
  def dispatch
    case request.subdomains.first
    when nil
      process_controller 'CmsController'
    when 'www'  
      process_controller 'CmsController'
    else
      process_controller 'BlogController'
    end
  end
  
  protected
  def process_controller(controller)
      cms = controller.constantize
      cms.process(request, response).out
      @performed_render = true    
  end
  
end
