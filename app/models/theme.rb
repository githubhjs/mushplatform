require 'yaml'
class Theme

  attr_accessor :name,:path

  Default_Theme_Name = 'default'
  
  def initialize(name, path)  
    @name, @path = name, path  
  end  
  
  def them_info
    @info ||= begin
      File.exist?("#{@path}/about.yml") ?  (YAML::load(File.open(@path+'/about.yml')) || {}) : {}
    rescue Exception => e
      {}
    end  
  end

  def title 
    them_info['title']||@name
  end

  def theme_type
    them_info['theme_type'] || 'default'
  end
  
  def is_sns_theme?
    theme_type == 'sns'
  end

  def description
    them_info['description'] || @name
  end
  
  def enable?
    them_info['enabled']||true
  end

  def path
    "#{RAILS_ROOT}/themes/#{self.name}"
  end

  def sns_theme_view
    "#{path}/views"
  end

  def liquid_layout
    "#{self.path}/templates/layout"
  end
  
  def index_liquid_template
    "#{self.path}/templates/entries"
  end
  
  def view_path
    "#{self.path}/templates"
  end

  def sns_layout #模板文件,在layouts文件里，叫default.html.erb
     "/layout/layout"
  end  

  def icon
    "/images/#{@name}/preview.png"
  end

  def self.find(name) #查找指定(name)的Theme  
    #    name =  default_theme_name if name.blank?
    name.blank? ? nil : self.new(name,theme_path(name))  
  end  
          
  def self.themes_root #所有theme的root  
    RAILS_ROOT + "/themes"
    #     "/home/liuikai/team/mushplatform" + "/themes"
    #    File.dirname(__FILE__) + "/../../themes"
  end  
      
  def self.theme_path(name) #指定(name)theme的path  
    "#{themes_root}/#{name}"
  end  
  
  def self.theme_from_path(path) #查找指定(path)的Theme  
    them_name = path.scan(/[-\w]+$/i).flatten.first
    self.new(them_name, path)
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
    Dir.glob("#{themes_root}/*").select do |theme_path|  
      File.readable?("#{theme_path}/about.yml")  
    end.compact  
  end
  
end