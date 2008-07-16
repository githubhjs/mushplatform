module ItemsHelper
  def list_article(args = {})
    {'articles' => ["article one", "article two"], 'limit' => args[:limit]}
  end
    
  def articles_template
    "{% for article in articles %}" +
    " <a href='#'>article</a> " +
    "{% endfor %}" + "limit : {{limit}} <br/>"
  end
end
