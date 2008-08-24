require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'iconv'
require File.dirname(__FILE__) + '/../../../../config/environment'
class ReadnovelCrawler
   
  Navigate_Url = %w{/ch/10.html /ch/1.html /ch/6.html /ch/3.html /ch/7.html
    /ch/12.html /ch/17.html /ch/8.html /ch/4.html /ch/9.html /ch/5.html /ch/2.html
  }
  
  Host = "http://www.readnovel.com"
  
  attr_accessor :site,:latest_artice
  
  def initialize(site)
    @site = site
#    @latest_artice = CrawlerArticle.find(:first,:order => "created_at_site desc",:select => "created_at_site")
  end
  
  def fetch
#    Navigate_Url.each do |path|
#      puts "#{Host}#{path}"
#      doc = hpricot_doc("#{Host}#{path}")
#      parse_article_pages(doc,path)
#    end
    doc = hpricot_doc("http://www.readnovel.com/all.html")
    doc.search("//div[@class='bothall']/table/tr/td/a").each do |a|
      archive = a.attributes['href']
      parse_archive_pages(archive)
    end
    return true
  end  
 
  private
  
  def parse_archive_pages(archive)
    doc = hpricot_doc("#{Host}#{archive}")
    doc.search("//table[@cellpadding='3']/tr/td/a").each do |a|
      summary_path = a.attributes['href']
      parse_article_summary(summary_path)
    end
  end
 
  def parse_article_pages(doc,path)
    return if doc.nil?
    page_div = doc.search("//div[@class='Pager']").first
    max_page = page_div.to_s.scan(/\d+(?=\.html)/).map{|p|p.to_i}.max
    page_href_perfix = path.gsub('.html','')
    (1..max_page).each do |page|
      page_href = "#{page_href_perfix}/#{page}.html"
      doc = hpricot_doc("#{Host}#{page_href}")
      unless doc.nil?
        doc.search('//li').each do |li|
          summary_path = (li/'h1/a').first.attributes['href']
          parse_article_summary(summary_path)
        end
      end
    end
  end
  
  def parse_article_summary(summary_path)
    return if Article.find_by_source("#{Host}#{summary_path}")
    iconv = Iconv.new("UTF-8//IGNORE","GB2312//IGNORE")
    summary_doc =  hpricot_doc("#{Host}#{summary_path}")
    unless summary_doc.nil?
      article = Article.new
      article.source="#{Host}#{summary_path}"
      begin
        category = iconv.iconv(summary_doc.search("//div[@class='left_list']/a")[1].inner_html)
        index_channel = Channel.find(1)
        current_channel = Channel.find_by_name(category)
        index_channel.add_child(current_channel = Channel.create(:name => category, :template_id => 1)) unless current_channel
        article.channel_id = current_channel.id
        
        article.title = iconv.iconv(summary_doc.search("//div[@class='readout']/h1/a").first.inner_html)
#       article.img = summary_doc.search("//div[@class='shucansu'/img]").first.attributes['src']
        summary_div = summary_doc.search("//div[@class ='xiangxi']").first
        li_tags = (summary_div/'ul/li')
        article.author = iconv.iconv((li_tags.first/'a').first.inner_html)
#       article.created_at_site = li_tags[2].inner_html.scan(/\d{4}-\d{2}-\d{2}/).first
        article.excerpt = iconv.iconv(summary_div.to_s).scan(/<\/strong>(.*)<br\s*\/>/m).first.first
#       article.site_id = site.id
        article.save
        CrawLogger.logger("Fetched article [#{category}] ##{article.id} #{article.title}")
        catalog_path = summary_div.search("//div[@class='mulutu']/a").first.attributes['href']
        parse_artilce_catalog(catalog_path,article)
      rescue Exception => e
        CrawLogger.logger(e.message) 
      end
    end
  end
  
  def parse_artilce_catalog(path,article)
    catalog_doc = hpricot_doc("#{Host}#{path}")
    unless catalog_doc.nil?
      catalog_li_tags = catalog_doc.search("//div[@class='mulu']/ul/li")
      catalog_hrefs = catalog_li_tags.map{|li|(li/'a').first.attributes['href']}
      catalog_hrefs.each_with_index do |detail_url,index|
        parse_article_content(detail_url,article,index+1)
      end
    end
  end
 
  def parse_article_content(detail_url,article,index)
    detail_doc = hpricot_doc(detail_url)
    iconv = Iconv.new("UTF-8//IGNORE","GB2312//IGNORE")
    unless detail_doc.nil?
#      article_content = Content.new
#      article_content.catelog_index = index
#      article_content.article_id = article.id
      content_div = detail_doc.search("//div[@class='shuneirong']")
      title = iconv.iconv((content_div/'h1/a').first.inner_html)
      elements_p = (content_div/'p')
      if elements_p.length > 0
        content = elements_p.map do |p|
          begin
           iconv.iconv(p.to_html)
          rescue Exception => e         
            CrawLogger.logger(e.message) 
          end
        end.join(' ')
      else
        (content_div/'iframe').remove
        (content_div/'h1').remove
        (content_div/'script').remove
        (content_div/'a').remove
        content = iconv.iconv(content_div.inner_html)
      end
      article_content = article.contents.create(:title => title, :body => content, :page => index)
#      article_content = Content.create(:title => title, :body => content, :page => index, :article_id => article.id)
      CrawLogger.logger("Fetched article content ##{article_content.id} #{title}")
    end
  end
  
  def hpricot_doc(url)
    doc = nil
    begin
      doc = Hpricot(open(url)) 
    rescue Exception => e
      CrawLogger.logger(e.message)
      nil
    end
    doc
  end
end
puts "begin to fetch"
site = Site.find_by_site_name('readnovel')
if site
  crawler = ReadnovelCrawler.new(site)
  crawler.fetch
  crawler.site.set_finish
  CrawLogger.logger("Finish to crawler #{crawler.site.site_name}")
end
