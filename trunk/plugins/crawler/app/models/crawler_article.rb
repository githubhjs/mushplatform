class CrawlerArticle < ActiveRecord::Base
  
  after_save :after_save_create_article
  
  def after_save_create_article
    article = Article.new
    article.title = self.title
    article.author = self.author
    article.subtitle = self.title
    article.display_title = self.summary
    article.crawler_article_id = self.id
    article.url = self.source_url
    article.channel_id = 1
    article.save
  end
  
end

