# Extend the Base ActionController to support themes
module ThememExt
  
  def self.included(base)
    base.class_eval do 
      helper_method :current_theme  
    end
  end
  
  protected

  def current_theme  
    @@stored_theme ||= Theme.find(configuration_theme_name)  
  end
  
  def default_theme_name
    "default"
  end
  
  def theme_layout #用于layout :theme_layout  
    current_theme.layout  
  end  
  
  def setup_themer 
    self.view_paths = ::ActionController::Base.view_paths.dup.unshift("#{Theme.themes_root}/#{current_theme.name}/views")  
  end
  
  def configuration_theme_name
    @@space_owner ||= User.find_by_user_name(request.subdomains.first)
    @@space_owner ? @@space_owner.theme_name : default_theme_name
  end
  
end