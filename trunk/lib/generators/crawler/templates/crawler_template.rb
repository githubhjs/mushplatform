require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'iconv'
require File.dirname(__FILE__) + '/../../../../config/environment'
class <%=class_name%>Crawler

  attr_accessor :site
  
  def initialize(site)
    @site = site
  end
  
end
puts "begin to fetch"
site = Site.find_by_site_name('<%=file_name%>')
if site
  crawler = ReadnovelCrawler.new(site)
  crawler.fetch
  crawler.site.set_finish
  CrawLogger.logger("Finish to crawler #{crawler.site.site_name}")
end