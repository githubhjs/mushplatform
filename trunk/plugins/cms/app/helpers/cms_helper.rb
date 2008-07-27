module CmsHelper

  def list_articles(args = {})
    channel_id = args.delete(:channel_id) || 1
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 20
    
    channel = Channel.find(channel_id)
    articles = Article.paginate_by_channel_id channel_id, :page => args.delete(:page), :order => order, :per_page => per_page
    {'articles' => articles, 'will_paginate_options' => {:path => "#{channel.permalink}"}}
  end
  
end
