require 'yaml'
class Sidebar
  
  attr_accessor :name,:path
  
  def initialize(name, path)  
    @name, @path = name, path  
  end

  def actived?(user_id)
    SidebarUser.find(:first,:conditions => "user_id=#{user_id} and sidebar_id = '#{self.sidebar_id}'")
  end

  def sidebar_info
    @info ||= begin
      File.exist?("#{@path}/description.yml") ?  (YAML::load(File.open(@path+'/description.yml')) || {}) : {}
    rescue Exception => e
      {}
    end  
  end
  
  def title 
    sidebar_info['title']||@name
  end

  def sidebar_id
    sidebar_info['sidebar_id']||@name
  end
  
  def description
    sidebar_info['description'] || @name
  end
  
  def enable?
    sidebar_info['enabled']||true
  end
  
  #===
def self.sidebars_root #所有sidebar的root  
    RAILS_ROOT + "/sidebars"
    #     "/home/liuikai/team/mushplatform" + "/sidebars"
    #    File.dirname(__FILE__) + "/../../sidebars"
  end  
      
  def self.sidebar_path(name) #指定(name)sidebar的path
    "#{sidebars_root}/#{name}"
  end  
      
  def self.sidebar_from_path(path) #查找指定(path)的sidebar
    name = path.scan(/[-\w]+$/i).flatten.first  
    self.new(name, path)  
  end  
      
  def self.find_all_sidebar
    installed_sidebars.inject([]) do |array, path|
      array << sidebar_from_path(path)
    end  
  end  
  
  def self.find(name) #查找指定(name)的Theme  
    name.blank? ? nil : self.new(name,sidebar_path(name))  
  end  

  def self.installed_sidebars
    search_sidebar_directory
  end  

  def liquid_template
   "#{sidebars_root}/views/content.liquid" 
  end

  def get_context
    
  end
  
  def self.search_sidebar_directory
    Dir.glob("#{sidebars_root}/*").select do |sidebar_path|
      File.directory?(sidebar_path) &&  File.readable?("#{sidebar_path}/description.yml")
    end.compact  
  end
  
end
