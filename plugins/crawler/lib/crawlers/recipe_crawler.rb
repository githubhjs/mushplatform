require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'iconv'
require File.dirname(__FILE__) + '/../../../../config/environment'
class RecipeCrawler
   
  Host = "http://www.5721.net"
  Navigate_Url = {
    '/Pregnant/morelist/News51.shtml' => 2, # 增加怀孕机会 => 孕前
    '/Pregnant/morelist/News52.shtml' => 6, # 孕期不适 => 孕不适 
    '/Pregnant/morelist/News53.shtml' => 7, # 产后减肥 => 月子
    '/Pregnant/morelist/News54.shtml' => 7, # 坐月子 => 月子 
    '/Pregnant/morelist/News55.shtml' => 6, # 药 膳 => 孕不适  
    '/Pregnant/morelist/News56.shtml' => 4, # 孕妇 => 孕中期
    '/Pregnant/morelist/News57.shtml' => 8, # 婴幼儿 => 婴幼儿
    '/Pregnant/morelist/News180.shtml' => 7 # 下奶 => 月子
  }
  
  attr_accessor :site,:latest_artice
  
  def initialize(site)
    @site = site
  end
  
  def fetch
    Navigate_Url.keys.each do |path|
      CrawLogger.logger "#{Host}#{path}"
      parse_article_list_page(path,Navigate_Url[path])
    end
    return true
  end  
 
  private
  
  def parse_article_list_page(path,channel_id)
    doc = hpricot_doc("#{Host}#{path}")
    doc.search("//table/tbody/tr/td[@id='fontzoom']/p/a").each do |a|
      page_path = a.attributes['href']
      page_path = page_path.dump.gsub(/\\/,'/').gsub(/\"/,'')
      parse_article_page(page_path,channel_id)
    end
  end
 
  def parse_article_page(page_path,channel_id)
    article =  Article.find_by_source("#{Host}#{page_path}")
    iconv = Iconv.new("UTF-8//IGNORE","GBK//IGNORE")
    doc = hpricot_doc("#{Host}#{page_path}")
    unless doc.nil?
      begin
        # save article
        unless article
          article = Article.new 
          article.source="#{Host}#{page_path}"
          article.channel_id = channel_id
          article.title = iconv.iconv(doc.search("//table/tbody/tr/td/h2/b").inner_html).strip
          article.title = iconv.iconv(doc.search("//table[@width='100%']/tr/td/b")[0].inner_html).strip if article.title.length == 0
          article.author = '孕妈咪食谱网'
          article.save
        end
        
        # save content
        big_table = doc.search("//td[@class='content']")
        big_table = doc.search("//td[@class='f14']") if big_table.length == 0
        (big_table/'table').remove
        (big_table/'link').remove
        (big_table/'style').remove
        (big_table/'script').remove
        (big_table/'div').remove
        (big_table/'a').remove
        (big_table/'header').remove
        content = iconv.iconv(big_table.inner_html)
        if article
#          CrawLogger.logger(content)
          article_content = article.contents[0]
          article_content.update_attributes(:title => article.title, :body => content) if article_content.body.length == 0
        else
          article.contents.create(:title => article.title, :body => content, :page => 1)
        end
        
        CrawLogger.logger("Fetched article [#{article.channel.name}] ##{article.id} #{article.title}")
      rescue Exception => e
        CrawLogger.logger(e)
      end
    end
  end
  
  def hpricot_doc(url)
    doc = nil
    begin
      doc = Hpricot(open(url)) 
    rescue Exception => e
      CrawLogger.logger(e)
      CrawLogger.logger(e.message)
      nil
    end
    doc
  end
end
puts "begin to fetch"
site = CrawlerSite.find_by_site_name('recipe')
if site
  crawler = RecipeCrawler.new(site)
  crawler.fetch
  crawler.site.set_finish
  CrawLogger.logger("Finish to crawler #{crawler.site.site_name}")
end
