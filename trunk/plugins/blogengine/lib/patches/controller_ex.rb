# Extend the Base ActionController to support themes
ActionController::Base.class_eval do 

  helper_method :current_theme  
  
  def current_theme  
    @@stored_theme ||= Theme.find(configuration_theme_name)  
  end
  
  def theme_layout #用于layout :theme_layout  
    current_theme.layout  
  end  
  
  def setup_themer #设置视图文件（View) 读取路径  
    self.view_paths = ::ActionController::Base.view_paths.dup.unshift("#{Theme.themes_root}/themes/#{current_theme.name}/views")  
  end

  def configuration_theme_name
    raise "this methods should be impleted"
  end
  
end