# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def timelong(time)
    time.strftime('%Y-%m-%d %H:%M:%S') if time
  end

  def display_sitebar(sidebars)
    
  end

  def user_icon(user_id)
    profile = UserProfile.find_by_user_id(user_id)
    profile ? profile.photo : '/images/default_usr_icon.gif'
  end
  
end
