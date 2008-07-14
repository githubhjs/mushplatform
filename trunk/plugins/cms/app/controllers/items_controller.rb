class ItemsController < ApplicationController
  
  def index
    template = "This is {{item}}. I love {{thing}} also"
    result = Mush::Template::Template.parse(template).render 'item' => 'apple', 'thing' => 'soccer'
    render :text => result
  end
    
  
end
