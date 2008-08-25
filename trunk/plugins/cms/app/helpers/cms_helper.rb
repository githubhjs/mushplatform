module CmsHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def article_link(article)
    channel = Channel.find(article['channel_id'])
    base_url = channel['permalink'] == '/' ? '' : channel['permalink']
    article_url = (article['permalink'] == '' or article['permalink'].nil?) ? article['id'] : article['permalink']
    link_to article['title'], "#{base_url}/article/#{article_url}"
  end

  def list_articles(args = {})
    channel_id = args.delete(:channel_id) #|| 1
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 20
    
    if channel_id
      channel = Channel.find(channel_id)
      articles = Article.paginate_by_channel_id channel_id, :page => args.delete(:page), :order => order, :per_page => per_page
    else
      channel = Channel.find(1)
      articles = Article.paginate :page => args.delete(:page), :order => order, :per_page => per_page
    end
    permalink = channel_permalink(channel.to_liquid)
    { 'articles' => articles, 'path' => permalink, 'will_paginate_options' => {:path => permalink} }
  end

  def channel_link(channel)
#    channel = Channel.find(channel['id'])
    link_to channel['name'], channel_permalink(channel)
  end
  
  def channel_permalink(channel)
    channel['permalink'] = (channel['permalink'] and channel['permalink'].length > 0) ? channel['permalink'] : "/channel/#{channel['id']}"
    channel['permalink'] == '/' ? '' : channel['permalink']    
  end
  
  def list_channels(args = {})
    channel_id = args.delete(:channel_id) || 1
    channel = Channel.find(channel_id)
    {'channels' => channel.all_children}
  end

  
end
