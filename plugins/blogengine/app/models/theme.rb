class Theme
  
  def initialize(name, path)  
    @name, @path = name, path  
  end  
       
  def layout(name) #模板文件,在layouts文件里，叫default.html.erb  
    File.dirname(__FILE__) + "/../../themes/#{name}/layouts/default"  
  end  
       
  def self.find(name) #查找指定(name)的Theme  
    self.new(name,theme_path(name))  
  end  
  
  def self.copy_themes_to_public
    public_path = RAILS_ROOT + "/public"
    self.search_theme_directory.each do |theme_path|
      %w{images stylesheets javascripts}.each do |media|
        if File.directory?("#{theme_path}/#{media}")
          public_theme_path = "#{public_path}/#{media}/#{File.basename(theme_path)}"
          FileUtils.makedirs(public_theme_path) unless File.directory?(public_theme_path)
          puts "try to cop #{theme_path}/images/* to #{public_theme_path}"
          FileUtils.cp_r("#{theme_path}/#{media}/.",public_theme_path) 
        end
      end
    end
  end
        
  def self.themes_root #所有theme的root  
    #    RAILS_ROOT + "/public/themes"  
    File.dirname(__FILE__) + "/../../themes"
  end  
  
  def self.theme_path(name) #指定(name)theme的path  
    "#{themes_root}/#{name}"
  end  
      
  def self.theme_from_path(path) #查找指定(path)的Theme  
    name = path.scan(/[-\w]+$/i).flatten.first  
    self.new(name, path)  
  end  
      
  def self.find_all  
    installed_themes.inject([]) do |array, path|  
      array << theme_from_path(path)   
    end  
  end  
      
  def self.installed_themes 
    search_theme_directory  
  end  
      
  def self.search_theme_directory 
    glob = "#{themes_root}/[a-zA-Z0-9]*"  
    Dir.glob(glob).select do |theme_path|  
      File.readable?("#{theme_path}/about.markdown")  
    end.compact  
  end
  
end
puts File.directory?("/home/liukai/team/mushplatform/plugins/blogengine/app/models/../../themes/test")
#p Theme.search_theme_directory