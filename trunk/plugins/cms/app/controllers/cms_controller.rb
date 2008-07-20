class CmsController < ApplicationController
  
  def index
    template = "This is {{item}}. I love [[article_list_by_all(limit=10,length=30)]] [[article_list_by_tag]]..."
    result = Liquid::Template.parse(template).render 'item' => 'apple'
    render :text => result
  end
  
  def dispatch
#    @dispatch_path    = Mephisto::Dispatcher.run(site, params[:path].dup)
#    @dispatch_action  = @dispatch_path.shift
#    @section          = @dispatch_path.shift
#    @dispatch_action == :error ? show_404 : send("dispatch_#{@dispatch_action}")
    channel = Channel.find_by_permalink("/#{recognize_permalink(params[:path])}")
    render :text => channel ? Liquid::Template.parse(channel.body).render : 'Page Not Found'
  end
  
  # returns an array with 3 values: [article_params, suffix, comment_id]
  def recognize_permalink(path)
    full_path = path.join('/')
  end  
end
