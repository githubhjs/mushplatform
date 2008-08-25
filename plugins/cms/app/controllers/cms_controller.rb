class CmsController < ApplicationController
  
  def index
    template = "This is {{item}}. I love [[article_list_by_all(limit=10,length=30)]] [[article_list_by_tag]]..."
    result = Liquid::Template.parse(template).render 'item' => 'apple'
    render :text => result
  end
  
  def dispatch
    path = params[:path]
    if path.index('article')
      channel_layout, content = recognize_article(path)
    else
      channel_layout, content = recognize_channel(path)
    end
    render :text => channel_layout ? Liquid::Template.parse(channel_layout).render('content' => content, 'page' => params[:page]) : 'Page Not Found'
  end
  
  def recognize_channel(path)
    page = path.index('page') ? path.delete_at(path.length-1) : params[:page]
    path.delete("page")
    id = path.delete('channel')
    channel = id ? Channel.find(path.first.to_i) : Channel.find_by_permalink("/#{recognize_permalink(path)}")
    return nil, nil unless channel
    if channel.template_id
      channel_layout = channel.template.body
      content = Liquid::Template.parse(channel.body).render('page' => page)
    else
      channel_layout = channel.body
    end
    return channel_layout, content
  end

  def recognize_article(path)
    begin
      article_id = path.at(path.index('article') + 1)
      content_page = path.index('page') ? path.last : 1
      
      case article_id
      when /^(\d*)$/
        article = Article.find(article_id)
      else
        article = Article.find_by_permalink(article_id)
      end
      article_content = Content.find_by_article_id_and_page(article.id, content_page)
    rescue
      # if couldn't find article, using channel's 
      # template to render 'Article Not Found'
      channel_layout, content = recognize_channel(path[0, 1])
      content = 'Article Not Found'
      return channel_layout, content
    end
    channel = article.channel
#    if channel.template_id
#      channel_layout = channel.template.body
#    else
#      channel_layout = channel.body
#    end
#    template = Template.find_by_name('Article')
#    article_template = template.body if template
#    article_template = Liquid::Template.file_system.read_template_file('article') unless article_template
#    content = Liquid::Template.parse(article_template).render('article' => article, 'content' => article_content, 'channel' => article.channel)
    contents = list_contents(article)
    channel_layout = "{{content}}"
    content = Liquid::Template.parse(channel.article_template.body).render('article' => article, 'content' => article_content, 'channel' => article.channel, 'contents' => contents)
    return channel_layout, content
  end
  
  def recognize_permalink(path)
    path.join('/')
  end  
end
