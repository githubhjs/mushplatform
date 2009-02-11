require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'iconv'
require File.dirname(__FILE__) + '/../../../../config/environment'
require 'general/craw_logger'
class CcidCrawler

  Host = "http://news.ccidnet.com/col/952/952.html"
  
  attr_accessor :site,:latest_artice, :url, :channel_id
  
  def initialize(url, channel_id)
     @url = url
     @channel_id = channel_id
#    @site = site
#    @latest_artice = CrawlerArticle.find(:first,:order => "created_at_site desc",:select => "created_at_site")
  end
  
  def fetch
    # crawl first page
#    parse_latest_update_pages("http://news.ccidnet.com/col/952/952.html")
#    parse_latest_update_pages("http://news.ccidnet.com/col/945/20071227.html")
    parse_latest_update_pages(@url)
    return true
  end  
 
  private
  
  def parse_latest_update_pages(update_page_path)
    doc = hpricot_doc(update_page_path)
    iconv = Iconv.new("UTF-8//IGNORE","GBK//IGNORE")
    unless doc.nil?
      doc.search("//td[@width='70%']/a").reverse_each{|a|
        article_page = a.attributes['href']
        article_title = iconv.iconv(a.inner_html)
        parse_article(article_page, article_title)
      }    
      next_page = doc.search("//a[@class='content']")
      if next_page
        #parse_latest_update_pages("http://news.ccidnet.com#{next_page.last.attributes['href']}")
        
        if iconv.iconv(next_page.first.inner_html) != "下一页&gt;&gt;"
          parse_latest_update_pages("http://news.ccidnet.com#{next_page.first.attributes['href']}")
        end
      end
    end
  end
  
  def parse_article(article_page,title)
    article = Article.find_by_source(article_page)
    iconv = Iconv.new("UTF-8//IGNORE","GBK//IGNORE")
    doc =  hpricot_doc(article_page)
    unless doc.nil?
      begin
        unless article
          article = Article.new 
          article.source= article_page
          article.channel_id = @channel_id
          article.title = title

          author_doc = doc.search("//td[@background='http://www.ccidnet.com/images/homepage/wz_left_2.gif']/table")[2]
          article.author = iconv.iconv(author_doc.search("//span")[3].inner_html)
          #CrawLogger.logger(article.author)
          article.save
          CrawLogger.logger("Fetched article ##{article.id} #{article.title}")

          parse_article_content(article_page, article, 1)
        end
      rescue Exception => e
        CrawLogger.logger(e)
      end
    end
  end
  
  def parse_article_content(detail_url,article,index)
    doc = hpricot_doc(detail_url)
    iconv = Iconv.new("UTF-8//IGNORE","GBK//IGNORE")
    unless doc.nil?
      title, content = "", ""
      title = iconv.iconv(doc.search("//h1[@class='titel']").inner_html)
      content_doc = doc.search("//td[@background='http://www.ccidnet.com/images/homepage/wz_left_2.gif']/table")[3]

      next_page = content_doc.search("//p/span/a{#class=content01}")

      content_div = content_doc.search("//tbody/tr/td/p/span")
      (content_div/'a').remove
      (content_div/'font').remove
      (content_div/'span').remove
      content = iconv.iconv(content_div.inner_html) if content_div

      article_content = article.contents.create(:title => title, :body => content, :page => index)
      CrawLogger.logger("Fetched article content ##{article_content.id} #{title}")

      if next_page and next_page.size > 0
        if iconv.iconv(next_page[0].inner_html) == "下一页&gt;&gt;"
          content_url = next_page[0].attributes['href']
          parse_article_content("http://news.ccidnet.com#{content_url}", article, index+1)
        end
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
puts "Begin to fetch"
#url = ARGV[0]
#channel_id = ARGV[1]

url = "http://news.ccidnet.com/col/5405/20071227.html"
channel_id = 11

crawler = CcidCrawler.new(url, channel_id)
crawler.fetch
CrawLogger.logger("Finish to crawler")
puts "Finished to fetch"
