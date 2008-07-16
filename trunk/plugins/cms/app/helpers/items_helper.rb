module ItemsHelper
  def list_article(args = {})
    {'articles' => ["article one", "article two"], 'limit' => args[:limit]}
  end
    
  def articles_template
    <<article
    <ul>
    {% for article in articles %}
     <li><a href='#'>{{ article }}</a></li>
    {% endfor %}
    <li> limit : {{limit}} </li>
    </ul>
article
  end
end
