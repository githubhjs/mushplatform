class ItemsController < ApplicationController
  
  def index
    template = "This is {{item}}. I love [[article_list_by_all]] [[article_list_by_tag]]..."
    result = Liquid::Template.parse(template).render 'item' => 'apple'
    render :text => result
  end
  
end
