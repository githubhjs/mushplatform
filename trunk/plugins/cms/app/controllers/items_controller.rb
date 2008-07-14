class ItemsController < ApplicationController
  
  def index
    template = "This is {{item}}"
    Liquid::Template.parse(template).render 'item' => params[:item]
  end
    
  
end