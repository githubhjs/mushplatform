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
    channel_id = args.delete(:channel_id) #|| 1
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 20
    will_args = args
    
    if channel_id
      channel = Channel.find(channel_id)
      articles = Article.paginate_by_channel_id channel_id, :page => args.delete(:page), :order => order, :per_page => per_page
    else
      channel = Channel.find(1)
      articles = Article.paginate :page => args.delete(:page), :order => order, :per_page => per_page
    end
    permalink = channel_permalink(channel.to_liquid)
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
    link_to article['title'], article_permalink(article), :title => article['title']
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
    if channel.children_count > 0
      prefix = "#{prefix}|--"
      channel.direct_children.each{|c|
        c.name = "#{prefix}#{c.name}"
        channel_list << c
        channels(channel_list, c, prefix)
      }
    else
      return 
    end
    channel_list
  end
  
end
