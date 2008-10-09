class CmsController < ApplicationController
  caches_page :dispatch
  
  def dispatch
    path = params[:path]
    if path.index('content')
      channel_layout, content = recognize_content(path)
    elsif path.index('article')
      channel_layout, content = recognize_article(path)
    elsif path.length == 0 or path.index('channel')
      channel_layout, content = recognize_channel(path)
    else
      channel = Channel.find_by_permalink("/#{path[0]}")
      if channel
        channel_layout, content = recognize_channel(path)
      else
        channel_layout, content = recognize_other(path)
      end
    end
    render :text => channel_layout ? Liquid::Template.parse(channel_layout).render('content' => content, 'page' => params[:page]) : 'Page Not Found'
  end
  
  def recognize_channel(path)
    page = path.index('page') ? path.delete_at(path.length-1) : params[:page]
    path.delete("page")
    id = path.delete('channel')
    channel = id ? Channel.find(path.first.to_i) : Channel.find_by_permalink("/#{recognize_permalink(path)}")
    return recognize_channel([]) unless channel
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
#      channel_layout, content = recognize_channel(path[0, 1])
#      content = 'Article Not Found'
      channel_layout, content = recognize_channel([])
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
    channel_layout = channel.template.body
    #content = Liquid::Template.parse(channel.article_template.body).render('channel' => channel, 'article' => article, 'content' => article_content, 'contents' => contents)
    content = Liquid::Template.parse(find_template(channel,'article')).render('channel' => channel, 'article' => article, 'content' => article_content, 'contents' => contents)
    return channel_layout, content
  end

  def recognize_content(path)
    begin
      article_id = path.at(path.index('article') + 1)
      
      case article_id
      when /^(\d*)$/
        article = Article.find(article_id)
      else
        article = Article.find_by_permalink(article_id)
      end
    rescue
      # if couldn't find article, using channel's 
      # template to render 'Article Not Found'
      channel_layout, content = recognize_channel(path[0, 1])
      content = 'Article Not Found'
      return channel_layout, content
    end
    channel = article.channel
    contents = list_contents(article)
    channel_layout = "{{content}}"
    content = Liquid::Template.parse(channel.content_template.body).render('channel' => channel, 'article' => article, 'contents' => contents)
    return channel_layout, content
  end

  def recognize_other(path)
    page = path.index('page') ? path.delete_at(path.length-1) : params[:page]
    path.delete("page")
    request_page = path[0]
    dynamics = path[1]
    channel = Channel.find(1)
    if channel.template_id
      channel_layout = channel.template.body
      content = Liquid::Template.parse(find_template(channel,request_page)).render('page' => page, 'dynamics' => dynamics)
    else
      channel_layout = channel.body
    end
    return channel_layout, content
  end
  
  def recognize_permalink(path)
    path.join('/')
  end  
  
  def find_template(channel,type)
    template = Template.find_by_name("#{channel.name}_#{type}")
    unless template
      template = Template.find_by_name("#{type}")
    end
    template ? template.body : "#{type.capitalize} Template Not Found"
  end
  
end
