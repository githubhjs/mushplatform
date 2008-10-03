require 'ccmw'

Article.class_eval do
  belongs_to :category, :class_name => 'ArticleCategory', :foreign_key => 'category_id'
end