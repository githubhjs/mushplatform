# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def timelong(time)
    time.strftime('%Y-%m-%d %H:%M:%S') if time
  end

  def display_sitebar(sidebars)
    
  end
  
end
