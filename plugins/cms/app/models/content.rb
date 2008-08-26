class Content < CachedModel
  belongs_to :article
  
  def not_first?
    page != 1 ? true : false
  end
  
  def not_last?
    last_content = Content.find_by_article_id_and_page(article_id, page+1)
    last_content ? true : false
  end
  
  def to_liquid
     atts = self.attributes.stringify_keys
     atts['not_first?'] = not_first?
     atts['previous_page'] = page - 1 if atts['not_first?']
     atts['not_last?'] = not_last?
     atts['next_page'] = page + 1 if atts['not_last?']
     atts
  end  
end
