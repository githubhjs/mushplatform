require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'iconv'
class ReadnovelCrawler
   
  Navigate_Url = %w{/ch/10.html /ch/1.html /ch/6.html /ch/3.html /ch/7.html
    /ch/12.html /ch/17.html /ch/8.html /ch/4.html /ch/9.html /ch/5.html /ch/2.html
  }
  
  Host = "http://www.readnovel.com"
  def fetch
    Navigate_Url.each do |path|
      doc = hpricot_doc("#{Host}#{path}")
      parse_article_pages(doc,path)
    end
  end  
 
  private
 
  def parse_article_pages(doc,path)
    page_div = doc.seach("//div[@class='Pager']").first
    max_page = page_div.to_s.scan(/\d+(?=\.html)/).map{|p|p.to_i}.max
    page_href_perfix = path.gsub('.html','')
    (1..max_page).each do |page|
      page_href = "#{page_href_perfix}#{page}.html"
      doc = hpricot_doc("#{host}#{page_href}")
      parse_article_link(doc)
    end
  end
 
  def parse_article_link(doc) 
    doc.search('//ul/li').each do |li|
      detail_path = (li/'h1/a').first.attributes('href')
      parse_article_detail(detail_path)
    end
  end 
 
  def parse_article_summary(detail_path)
    iconv = Iconv.new("UTF-8//IGNORE","GB2312//IGNORE")
    detail_doc =  hpricot_doc("#{host}#{detail_path}")
    unless detail_doc.nil?
      img_src = detail_doc.search("//div[@class='shucansu'/img]").frist.attributes['src']
      summary_div = detail_doc.search("//div[@class ='xiangxi']")
      li_tags = (summary_div/'ul/li')
      author = iconv.iconv((li_tags.first/'a').first.inner_html)
      create_at = li_tags[2].inner_html.scan(/\d{4}-\d{2}-\d{2}/)
      summary = summary_div.to_s.scan(/<\/strong>(.*)<br/).frist.first 
      catalog_path = summary_div.search("//div[@class='mulutu']/a").first.attributes['href']
    end
  end
  
  def parse_artilce_catalog(path)
    catalog_path = hpricot_doc("#{Host}#{path}")
    unless catalog_path.nil?
      catalog_li_tags = doc.search("//div[@class='mulu']/ul/li")
      catalog_hrefs = catalog_li_tags.map{|li|(li/'a').first.attributes['href']}
      catalog_hrefs.each_with_index do |detail_url,index|
        parse_article_detail(detail_url,index)
      end
    end
  end
 
  def parse_article_content(detail_url,index)
    detail_doc = hpricot_doc(detail_url)
    iconv = Iconv.new("UTF-8//IGNORE","GB2312//IGNORE")
    unless detail_doc.nil?
      content_div = deail_doc.search("//div[@class='shuneirong']")
      index_name = iconv.iconv((content_div/'h1/a').frist.inner_html)
      contents = (content_div/'p').map do |p|
        iconv.iconv(p.inner_html)
      end.join(' ')
    end
  end
  
  def hpricot_doc(url)
    doc = nil
    begin
      doc = Hpricot(open(url)) 
    rescue Exception => e
      nil
    end
    doc
  end
 
 
end
