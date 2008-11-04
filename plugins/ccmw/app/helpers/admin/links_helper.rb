module Admin::LinksHelper
  def link_categories
    links = Link.find_by_sql("select distinct category from links")
    links.collect{|link| link.category }.sort
  end
  
  def link_categories_links(selected)
    categories = link_categories.collect{|link|
      style = "class='current'" if link == selected
      "<li><a href='?category=#{link}' #{style}>#{link}</a></li>"
    }.join(' | ')
    style = "class='current'" if selected.nil? or selected == ''
    (["<li><a href='?category=' #{style}>#{t 'text.link.all_links'}</a></li> | "] << categories).flatten
  end
end