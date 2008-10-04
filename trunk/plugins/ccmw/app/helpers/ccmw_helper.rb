#A demo to show how extend a exist extension point
#This extension should be regiestered for MenubarExtension by CmsExsension

module CcmwHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormOptionsHelper
  
  # Scriptlets
  def list_articles_by_categories(args = {})
    categories = args.delete(:categories)
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 8
    offset = args.delete(:offset) || 0
    paginate = args.delete(:paginate) || "true"
    will_args = args
    
    conditions = ""
    if categories and categories.length > 0
      categories_id = categories.split('+').collect{|name| ArticleCategory.find_by_name(name)}.collect{|category| category.id}.join(",")
      conditions = "category_id in (#{categories_id})"
    else
    end
    if paginate == "true"
      articles = Article.paginate :page => args.delete(:page), :order => order, :per_page => per_page,
                                  :conditions => conditions
    else
      articles = Article.find :all, :page => args.delete(:page), :order => order, :per_page => per_page,
                              :conditions => conditions, :offset => offset
    end
    #permalink = channel_permalink(channel.to_liquid)
    permalink = ''
    { 'articles' => articles, 'path' => permalink, 'will_paginate_options' => {:path => permalink}.merge(will_args) }
  end
  
  def list_categories_by_category(args ={})
    category = args.delete(:category)
    categories = ArticleCategory.find_all_by_category(category)
    { 'categories' => categories }
  end
  
  def list_links_by_category(args = {})
    category = args.delete(:category)
    links = Link.find_all_by_category(category)
    { 'links' => links }
  end
  
  def list_tags_by_category(args ={})
    category = args.delete(:category)
    order = args.delete(:order) || "position DESC"
    tags = Tag.find_all_by_category(category, :order => order)
    { 'tags' => tags }
  end
  
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
