class ArticleCategory < CachedModel
  has_many :articles, :class_name => 'Article'
  
  def before_create
    self.category = 'N/A' if self.category.empty?
  end
  
  def to_liquid
     self.attributes.stringify_keys
  end     
  
end
