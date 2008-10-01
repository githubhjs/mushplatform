#A demo to show how extend a exist extension point
#This extension should be regiestered for MenubarExtension by CmsExsension

module CcmwHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormOptionsHelper
  include TagsHelper
  
  def add_mainmenu
    <<menu
<li><a href="/admin/article_categories" id="ccmw">CCMW &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
    <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
            <li><a href="/admin/article_categories">Categories</a></li>
            <li><a href="/admin/tags">Tags</a></li>
            <li><a href="/admin/links">Links</a></li>
    </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
</li>
menu
  end
  
  def add_article_extra_attributes(article)
    output = ""
    output << "<tr class=\"form-field\"><th scope=\"row\" valign=\"top\"><label for=\"article_status\">Category</label></th><td>"
    output << "<select name=\"article[category_id]\" id=\"article_category\">"
    output << "<option>Selete Category</option>"
    output << option_groups_from_collection_for_select(view_categories, :article_categries, :name, :id, :name, article.category_id)
    output << "</select>"
    output << "</td></tr>"
    output
  end
  
  def view_categories
    view_categories = {}
    acs = ArticleCategory.find(:all)
    for ac in acs
      article_categories = {}
      if view_categories[ac.name]
        view_category =  view_categories[ac.name]
      else
        view_category = ViewCategory.new(ac.category)
        view_categories[ac.name] = view_category
      end
      view_category.article_categries << ac
    end
    view_categories.values
  end
  
end

class ViewCategory
  attr_accessor :name, :article_categries 
  def initialize(name)
    @name = name
    @article_categries ||= []
  end
end
