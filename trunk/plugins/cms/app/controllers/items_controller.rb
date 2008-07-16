class ItemsController < ApplicationController
  
  def index
    template = "This is {{item}}. I love [[article_list_by_all(limit=10,length=30)]] [[article_list_by_tag]]..."
    result = Liquid::Template.parse(template).render 'item' => 'apple'
    render :text => result
  end
  
end
