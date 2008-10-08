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
    sidebar_info['enable']||false
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

  def path
    "#{Sidebar.sidebars_root}/#{self.name}"
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
    name.blank? || !File.exist?(sidebar_path(name)) ? nil : self.new(name,sidebar_path(name))  
  end  

  def self.installed_sidebars
    search_sidebar_directory
  end  

  def liquid_template
    "#{self.path}/views/content.liquid"
  end

  def edit_template
    "#{self.path}/views/edit.liquid"
  end
  
  def get_edit_context(options = {})
    helper = get_helper
    helper.get_edit_context(options)
  end
  
  def get_context(options = {})
    helper = get_helper
    helper.get_context(options)
  end

  def get_helper
    helper = begin
      Object.const_get(helper_name)
    rescue Exception => e
      require helper_path
      Object.const_get(helper_name)
    end
    helper
  end
  
  def helper_name
    self.name.split('_').map{|nm|nm.capitalize}.join('')+"SidebarHelper"
  end

  def helper_path
    return "#{path}/helpers/#{self.name}_sidebar_helper"
  end
  
  def get_content(options)
    pares_template(liquid_template,{'entries' => get_context(options)})
  end
  
  def get_edit_page(options)
    pares_template(edit_template,get_edit_context(options))
  end  
  
  def pares_template(template_path,options = {})
    content = begin
      Liquid::Template.file_system = Liquid::LocalFileSystem.new(template_path)
      parse = Liquid::Template.parse(IO.read(template_path))
      parse.render(options)
    rescue Exception => e
#      raise e.message
      'No info'
    end
    content
  end

  def self.search_sidebar_directory
    Dir.glob("#{sidebars_root}/*").select do |sidebar_path|
      File.directory?(sidebar_path) &&  File.readable?("#{sidebar_path}/description.yml")
    end.compact  
  end
  
end
