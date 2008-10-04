require 'paginator'
module CmsHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include TagsHelper

  # Scriptlets
  def show_html(args = {})
    template_name = args.delete(:template)
    if template_name
      return Template.find_by_name(template_name).body
    end
  end
  
  def list_channels(args = {})
    channel_id = args.delete(:channel_id) || 1
    channel = Channel.find(channel_id)
    {'channels' => channel.all_children}
  end

  def list_articles(args = {})
    channel_id = args.delete(:channel_id) || 1
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 20
    offset = args.delete(:offset) || 0
    page = args.delete(:page) || 1
    will_args = args
    conditions = "channel_id = #{channel_id}"
    
    channel = Channel.find(channel_id)
    articles = Article.paginate :page => page, :order => order, :per_page => per_page,
                                :conditions => conditions, :offset => offset
    permalink = channel_permalink(channel.to_liquid)
    { 'articles' => articles, 'path' => permalink, 'will_paginate_options' => {:path => permalink}.merge(will_args) }
  end
  
  def list_articles_by_tags(args = {})
    tags = args.delete(:tags)
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 20
    offset = args.delete(:offset) || 0
    page = args.delete(:page) || 1
    will_args = args
    if tags
      articles = tag_paginator(Article, tags.split('+'), nil, per_page.to_i, page.to_i, offset)
    end
    permalink = "/tags/#{tags}"
    { 'articles' => articles, 'path' => permalink, 'will_paginate_options' => {:path => permalink}.merge(will_args) }
  end  
  
  def list_tags(args ={})
    tags = []
    tag_cloud Tag.counts, %w(tag1 tag2 tag3 tag4) do |tag, css_class|
#      link_to tag.name, { :action => :tag, :id => tag.name }, :class => css_class
      atts = tag.attributes.stringify_keys
      atts['css_class'] = css_class
      tags << atts
    end
    {'tags' => tags}
  end
  
  # Helper or Filter
  def article_permalink(article)
    channel = Channel.find(article['channel_id'])
    base_url = channel_permalink(channel.to_liquid)
    article_url = (article['permalink'] == '' or article['permalink'].nil?) ? article['id'] : article['permalink']
    "#{base_url}/article/#{article_url}"
  end

  def article_link(article)
    
    title = (article['display_title'] and article['display_title'].length > 0) ? title = article['display_title'] : title = article['title']
    link_to title, article_permalink(article), :title => article['title']
  end
  
  def article_content_link(article)
    link_to article['title'], "#{article_permalink(article)}/content", :title => article['title']
  end
  
  def content_link(content)
    article = Article.find(content['article_id'])
    "#{article_permalink(article.to_liquid)}/page/#{content['page']}"
    link_to content['title'], "#{article_permalink(article.to_liquid)}/page/#{content['page']}", :title => content['title']
  end
  
  def channel_link_by_article(article)
    channel = Channel.find(article['channel_id'])
    channel_link channel.to_liquid
  end
  
  def channel_permalink(channel)
    channel['permalink'] = (channel['permalink'] and channel['permalink'].length > 0) ? channel['permalink'] : "/channel/#{channel['id']}"
    channel['permalink'] == '/' ? '' : channel['permalink']    
  end
  
  def channel_link(channel)
    link_to channel['name'], channel_permalink(channel), :title => channel['name']
  end
  
  def list_contents(article)
    article.contents.find(:all, :select => "id, title, page, article_id")
  end
  
  def channels_select
    channels.collect {|p| [ p.name, p.id ] }
  end
  
  def channels(channel_list = [], channel = nil, prefix = '')
    unless channel
      channel = Channel.find(1) 
      channel_list << channel
    end
    if !channel.child? and channel.children_count > 0
      prefix = "#{prefix}|--"
      channel.direct_children.each{|c|
        c.name = "#{prefix}#{c.name}"
        channel_list << c
        channels(channel_list, c, prefix)
      }
    else
      return channel_list
    end
    channel_list
  end
  
  # paginate a call to find_tagged_with
  # klass is the tagged class
  # tag is the tag to find
  # count is the total number of items with that tag, if nil count_tags is called
  # per_page is numbe rof items per page
  # page is the page we are on
  # order is the order to return the items in
  def tag_paginator(klass, tag, count=nil, per_page=10, page=1, offset = 0, order='created_at DESC')
    count ||= klass.count_tags(tag)
    pager = ::Paginator.new(count, per_page) do |offset, per_page|
      klass.find_tagged_with(tag, :order => order, :limit => per_page, :offset => offset)
    end

    page ||= 1
    returning WillPaginate::Collection.new(page, per_page, count) do |p|
      p.replace pager.page(page).items
    end
  end  
  
  # format time to long style
  def timelong( time )
    time.strftime('%Y-%m-%d %H:%M:%S') if time
  end
  
  # format time to short style
  def dateshort( time )
    time.strftime('%Y-%m-%d') if time
  end
  
end
