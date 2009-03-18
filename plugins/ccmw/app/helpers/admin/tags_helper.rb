module Admin::TagsHelper
  def tag_categories
    tags = Tag.find_by_sql("select distinct category from tags where category is not null and category != ''")
    tags.collect{|tag| tag.category }.sort
  end
  
  def tag_categories_links(selected)
    categories = tag_categories.collect{|tag|
      style = "class='current'" if tag == selected
      "<li><a href='?category=#{tag}' #{style}>#{tag}</a></li>"
    }.join(' | ')
    style = "class='current'" if selected.nil? or selected == ''
    (["<li><a href='?category=' #{style}>#{t 'text.tag.all_tags'}</a></li> | "] << categories).flatten
  end
end