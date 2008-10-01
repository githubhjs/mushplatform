class ArticleCategory < CachedModel
  
  def before_create
    self.category = 'N/A' if self.category.empty?
  end
  
end
