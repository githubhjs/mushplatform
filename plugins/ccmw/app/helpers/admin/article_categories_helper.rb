module Admin::ArticleCategoriesHelper
  def categories
    article_categories = ArticleCategory.find_by_sql("select distinct category from article_categories")
    article_categories.collect{|tag| tag.category }.sort
  end
  
  def categories_links(selected)
    all_categories = categories.collect{|tag|
      style = "class='current'" if tag == selected
      "<li><a href='?category=#{tag}' #{style}>#{tag}</a></li>"
    }.join(' | ')
    style = "class='current'" if selected.nil? or selected == ''
    (["<li><a href='?category=' #{style}>#{I18n.t 'text.category.all_categories'}</a></li> | "] << all_categories).flatten
  end
end