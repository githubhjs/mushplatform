require 'yaml'
class Theme
  
  def initialize(name, path)  
    @name, @path = name, path  
  end  
  
  def them_info
    @info ||= (YAML::load(File.open(path+'/theme.yml')) || {})
  end

  def title 
    @info[:title]
  end

  def description
    @info[:description]
  end
  
  def enable?
    @info[:enabled]
  end
  
  def layout #模板文件,在layouts文件里，叫default.html.erb  
    self.path + "/layouts/default"
  end  

  def icon
    "/images/#{self.path}/preview.png"
  end

  def self.find(name) #查找指定(name)的Theme  
    #    name =  default_theme_name if name.blank?
    name.blank? ? nil : self.new(name,theme_path(name))  
  end  
          
  def self.themes_root #所有theme的root  
    RAILS_ROOT + "/themes"
    #    File.dirname(__FILE__) + "/../../themes"
  end  
      
  def self.theme_path(name) #指定(name)theme的path  
    "#{themes_root}/#{name}"
  end  
      
  def self.theme_from_path(path) #查找指定(path)的Theme  
    name = path.scan(/[-\w]+$/i).flatten.first  
    self.new(name, path)  
  end  
      
  def self.find_all_theme  
    installed_themes.inject([]) do |array, path|  
      array << theme_from_path(path)   
    end  
  end  
      
  def self.installed_themes 
    search_theme_directory  
  end  
  
  def self.default_theme_name
    "default"
  end
  
  def self.default_theme_path
    RAILS_ROOT + "/app/views/blogs"
  end

  def self.search_theme_directory 
    glob = "#{themes_root}/[-_a-zA-Z0-9]+"  
    Dir.glob(glob).select do |theme_path|  
      File.readable?("#{theme_path}/about.markdown")  
    end.compact  
  end
  
end
#p Theme.search_theme_directory