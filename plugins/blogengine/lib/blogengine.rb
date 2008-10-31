# Blogengine
module BlogEngine
  require File.dirname(__FILE__) +'/scriptlets'
    
  def self.copy_themes_to_public
    public_path = RAILS_ROOT + "/public"
    #     public_path = "/home/liuikai/team/mushplatform/public"
    Theme.search_theme_directory.each do |theme_path|
      %w{images stylesheets javascripts}.each do |media|
        if File.directory?("#{theme_path}/#{media}")
          public_theme_path = "#{public_path}/#{media}/#{File.basename(theme_path)}"
          FileUtils.makedirs(public_theme_path) unless File.directory?(public_theme_path)
          #puts "try to cop #{theme_path}/#{media}/* to #{public_theme_path}"
          cp_r("#{theme_path}/#{media}",public_theme_path)
        end
      end
      preview = "#{theme_path}/preview.png"
      if File.exist?(preview)
        FileUtils.cp(preview,"#{public_path}/images/#{File.basename(theme_path)}")
      end
    end
  end
  
  
  def self.cp_r(form_path,to_path)
    Dir.glob("#{form_path}/*") do |f_path|
      if File.directory?(f_path)
        cp_r(f_path,"#{to_path}/#{File.basename(f_path)}") if File.stat(f_path).readable?
      elsif File.file?(f_path) && File.readable?(f_path)
        FileUtils.makedirs(to_path) unless File.directory?(to_path)
        FileUtils.cp(f_path,to_path)
      end
    end
  end
  
  def self.init
    self.copy_themes_to_public
  end 
    
end