class CmsController < ApplicationController
  
  def index
    template = "This is {{item}}. I love [[article_list_by_all(limit=10,length=30)]] [[article_list_by_tag]]..."
    result = Liquid::Template.parse(template).render 'item' => 'apple'
    render :text => result
  end
  
  def dispatch
    channel = Channel.find_by_permalink("/#{recognize_permalink(params[:path])}")
    if channel.template_id
      channel_layout = channel.template.body
      content = Liquid::Template.parse(channel.body).render
    else
      channel_layout = channel.body
    end
    render :text => channel ? Liquid::Template.parse(channel_layout).render('content' => content) : 'Page Not Found'
  end
  
  def recognize_permalink(path)
    full_path = path.join('/')
  end  
end
