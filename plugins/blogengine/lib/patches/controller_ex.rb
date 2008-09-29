# Extend the Base ActionController to support themes
module ThememExt
  
  def self.included(base)
    base.class_eval do 
      helper_method :current_theme
      layout         :theme_layout
      before_filter :setup_themer
    end
  end
  
  protected

  def space_owner
    session[:current_space_owner] ||= User.find_by_user_name(request.subdomains.first)
  end

  def current_theme
    debugger
    puts "++++++++++++++++++++++++++++++++++*********************#{space_owner.theme_name}"
    space_owner.theme ||= Theme.find(space_owner.theme_name)
  end
  
  def reset_theme
    seesion[:current_space_owner] = User.find_by_user_name(request.subdomains.first)
  end

  def theme_layout #用于layout :theme_layout  
    current_theme ? current_theme.layout  : default_layout
  end  

  #when no theme seted,should use default layout
  def default_layout
    raise "should be implemented"
  end

  def setup_themer #设置视图文件（View) 读取路径  
    self.view_paths = ::ActionController::Base.view_paths.dup.unshift("#{Theme.themes_root}/#{current_theme.name}/views")  if current_theme
  end
  
end