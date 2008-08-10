class CrawlerArticle < ActiveRecord::Base
  
  after_save :after_save_create_article
  
  def after_save_create_article
    article = Article.new
    article.title = self.title
    article.author = self.author
    article.subtitle = self.summary
    article.display_title = self.summary
    article.crawler_article_id = self.id
    article.url = self.source_url
    article.save
  end
end

