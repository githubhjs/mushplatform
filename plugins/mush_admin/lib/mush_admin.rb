module MushAdmin
  
  require File.dirname(__FILE__) +'/extensions'
  
  def self.init
  end

  I18n.load_path << File.dirname(__FILE__) + '/locale/en-US.yml'
  I18n.load_path << File.dirname(__FILE__) + '/locale/zh-CN.yml'  
end
