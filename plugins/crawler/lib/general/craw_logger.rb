require 'logger'
require 'fileutils'
module CrawLogger  
  
  Default_Loger_Path = File.dirname(__FILE__) +"/../../log"
  FileUtils.makedirs(Default_Loger_Path) unless File.directory?(Default_Loger_Path)
  
  Craw_Logger = Logger.new("#{Default_Loger_Path}/crawler_log"||STDOUT , 'daily')
     
  class << self
    
    def logger(info)
      Craw_Logger.info(info)
    end
    
  end
   
end
