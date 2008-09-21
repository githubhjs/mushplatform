# Blogengine
module BlogEngine
  
  def self.copy_themes_to_public
    public_path = RAILS_ROOT + "/public"
    Theme.search_theme_directory.each do |theme_path|
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
  
  def self.init
    copy_themes_to_public
  end 
    
end
