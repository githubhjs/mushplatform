module ItemsHelper
  def list_article
    {'articles' => ["article one", "article two"]}
  end
    
  def articles
    "{% for article in articles %}" +
    " <a href='#'>article</a> " +
    "{% endfor %}"
  end
end
