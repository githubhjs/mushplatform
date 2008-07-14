class ItemsController < ApplicationController
  
  def index
    template = "This is {{item}}"
    result = Mush::Template::Template.parse(template).render 'item' => params[:item]
    render :text => result
  end
    
  
end
