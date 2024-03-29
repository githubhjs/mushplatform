class CrawlerGenerator < Rails::Generator::NamedBase  
  def manifest  
    record do |m|  
      unless File.exist?("/plugins/crawler/lib/crawlers/#{file_name}_crawler.rb")
        m.template "crawler_template.rb", "/plugins/crawler/lib/crawlers/#{file_name}_crawler.rb"
      end
    end  
  end 
end
