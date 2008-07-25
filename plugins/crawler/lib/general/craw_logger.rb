require 'logger'
module CrawLogger
  
  Craw_Logger = Logger.new(CraweConfig::logger_path||STDOUT , 'daily')
     
  class << self
    
    def logger(info)
      Craw_Logger.info(info)
    end
    
  end
   
end
