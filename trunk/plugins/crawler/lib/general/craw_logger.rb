require 'logger'
require 'fileutils'
module CrawLogger  
  
  Default_Loger_Path =  "#{RAILS_ROOT}/log"
  FileUtils.makedirs(Default_Loger_Path) unless File.directory?(Default_Loger_Path)
  
  Craw_Logger = Logger.new("#{Default_Loger_Path}/crawler.log"||STDOUT , 'daily')
     
  class << self
    
    def logger(info)
      Craw_Logger.info(info)
    end
    
  end
   
end
