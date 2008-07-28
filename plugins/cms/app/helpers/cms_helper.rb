module CmsHelper
  include ActionView::Helpers::UrlHelper

  def article_link(article)
    channel = Channel.find(article['channel_id'])
    base_url = channel['permalink'] == '/' ? '' : channel['permalink']
    article_url = article['permalink'] == '' ? article['id'] : article['permalink']
    link_to article['title'], "#{base_url}/article/#{article_url}"
  end

  def list_articles(args = {})
    channel_id = args.delete(:channel_id) || 1
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 20
    
    channel = Channel.find(channel_id)
    articles = Article.paginate_by_channel_id channel_id, :page => args.delete(:page), :order => order, :per_page => per_page
    { 'articles' => articles, 'path' => channel.permalink, 'will_paginate_options' => {:path => channel.permalink} }
  end


  
end
