require 'rubygems'
require 'scrubyt'
require 'iconv'
class CrawlerTest
  
  def initialize
    
  end
  
  def fetch
    puts 'begin...'
    #    Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE",text) 
    #    conv = Iconv.new("UTF-8//IGNORE","GB2312//IGNORE")
    #    google_data = Scrubyt::Extractor.define do
    #      #Perform the action(s)
    #      fetch 'http://www.readnovel.com/partlist/46009/'
    #      #Construct the wrapper
    #      example_info = Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE","第一章")
    #      puts example_info
    #      link "#{example_info}" do
    #        url "href", :type => :attribute
    #      end
    #    end
    #    puts google_data.to_xml
    google_data = Scrubyt::Extractor.define do
      #Perform the action(s)
      fetch 'http://www.google.cn'
      fill_textfield 'q', 'ruby'
      submit
      #Construct the wrapperinfo
      info = Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE","Ruby 程序设计语言官方网站").join 
      puts info
      link "#{info}" do
        url "href", :type => :attribute
      end
      next_page "Next", :limit => 2
    end
    puts google_data.to_xml
  end
end
test = CrawlerTest.new
test.fetch