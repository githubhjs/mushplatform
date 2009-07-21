#A demo to show how extend a exist extension point
#This extension should be regiestered for MenubarExtension by CmsExsension

module CcmwHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormOptionsHelper
  
  # Scriptlets
  def list_articles_by_categories(args = {})
    categories = args.delete(:categories)
    categories = args.delete(:dynamics) if categories.nil? and args[:dynamics]
    status = args.delete(:status)
    order = args.delete(:order) || 'created_at DESC'
    page = args.delete(:page)
    per_page = args.delete(:per_page) || 8
    offset = args.delete(:offset) || 0
    paginate = args.delete(:paginate) || "true"
    will_args = args
    
    conditions = ""
    if categories and categories.length > 0
      categories_id = categories.split('+').collect{|name| ArticleCategory.find_by_name(name)}.collect{|category| category.id if category}.join(",")
      conditions = "category_id in (#{categories_id})"
    end
    if status
      order = "#{status} DESC, #{order}"
    end
    if paginate == "true"
      articles = Article.paginate :page => page, :order => order, :per_page => per_page,
                                  :conditions => conditions
    else
      articles = Article.find :all, :order => order, :offset => offset, :limit => per_page,
                              :conditions => conditions
    end
    #permalink = channel_permalink(channel.to_liquid)
    permalink = "/categories/#{categories}"
    { 'articles' => articles, 'path' => permalink, 'will_paginate_options' => {:path => permalink}.merge(will_args) }
  end
  
  def list_categories_by_category(args ={})
    category = args.delete(:category)
    categories = ArticleCategory.find_all_by_category(category)
    { 'categories' => categories }
  end
  
  def list_links_by_category(args = {})
    category = args.delete(:category)
    order = args.delete(:order) || "position DESC"
    links = Link.find(:all, :conditions => "category = '#{category}' and filename is null", :order => order)
    { 'links' => links }
  end

  def list_image_links_by_category(args = {})
    category = args.delete(:category)
    order = args.delete(:order) || "position DESC"
    links = Link.find(:all, :conditions => "category = '#{category}' and filename is not null", :order => order)
    { 'links' => links }
  end
  
  def list_tags_by_category(args ={})
    category = args.delete(:category)
    path = args.delete(:path)
    page = args.delete(:page)
    per_page = args.delete(:per_page) || 8
    offset = args.delete(:offset) || 0
    order = args.delete(:order) || "position DESC"
    paginate = args.delete(:paginate) || "false"
    will_args = args
    
    if paginate == "true"
      tags = Tag.paginate :page => page, :order => order, :per_page => per_page,
                          :conditions => "category = '#{category}'"
    else
      tags = Tag.find_all_by_category(category, :order => order)
    end
    { 'tags' => tags, 'path' => path, 'will_paginate_options' => {:path => path}.merge(will_args) }
  end

  def list_journals_by_year(args ={})
    category = args.delete(:category)
    year = args.delete(:dynamics) if args[:dynamics]
    path = args.delete(:path)
    page = args.delete(:page)
    per_page = args.delete(:per_page) || 8
    offset = args.delete(:offset) || 0
    order = args.delete(:order) || "position DESC"
    paginate = args.delete(:paginate) || "false"
    will_args = args

    year =  years_of_journals['years'].last unless year

    if paginate == "true"
      tags = Tag.paginate :page => page, :order => order, :per_page => per_page,
                          :conditions => "category = '#{category}' and substring(name, 1, 4) = '#{year}'"
    else
      tags = Tag.find_all_by_category(category, :order => order)
    end
    { 'tags' => tags, 'path' => path, 'will_paginate_options' => {:path => path}.merge(will_args) }
  end
  
  def focus_images_from_links(args ={})
    category = args.delete(:category)
    order = args.delete(:order) || "position DESC"
    links = Link.find_all_by_category(category, :order => order)
    files, urls, texts = [], [], []
    links.each{|link|
      files << link.public_filename
      urls << link.url
      texts << link.name
    }
    { 'files' => files.join('|'), 'urls' => urls.join('|'), 'texts' => texts.join('|') }
  end

  def years_of_journals(args = {})
    tgs = Tag.find_all_by_category('期刊')
    @tags = Hash.new
    tgs.each { |t|
      j_name = t.name[0,4]
      @tags[j_name] = t.id unless @tags.has_key?(j_name)
    }
    { 'years' => @tags.keys }
  end
  
  def add_mainmenu
    menu="
      <li><a href='/admin/article_categories' id='ccmw'>#{I18n.t 'text.menu.ccmw'} &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
          <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
                  <li><a href='/admin/article_categories'>#{I18n.t 'text.menu.categories'}</a></li>
                  <li><a href='/admin/tags'>#{I18n.t 'text.menu.tags'}</a></li>
                  <li><a href='/admin/links'>#{I18n.t 'text.menu.links'}</a></li>
                  <li><a href='/admin/blogs'>#{I18n.t 'text.menu.blogs'}</a></li>
                  <li><a href='/admin/blocks'>#{I18n.t 'text.menu.blocks'}</a></li>
          </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
      </li>"
    menu
  end
  
  def add_article_extra_attributes(article)
    output = ""
    output << "<tr class=\"form-field\"><th scope=\"row\" valign=\"top\"><label for=\"article_status\">#{I18n.t 'text.article.category'}</label></th><td>"
    output << "<select name=\"article[category_id]\" id=\"article_category\">"
    output << "<option>#{I18n.t 'text.select'}</option>"
    output << option_groups_from_collection_for_select(view_categories, :article_categries, :name, :id, :name, article.category_id)
    output << "</select>"
    output << "</td></tr>"
    output
  end
  
  def view_categories
    view_categories = {}
    acs = ArticleCategory.find(:all)
    for ac in acs
      if view_categories[ac.category]
        view_category =  view_categories[ac.category]
      else
        view_category = ViewCategory.new(ac.category)
        view_categories[ac.category] = view_category
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
