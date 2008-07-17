class Admin::TemplatesController < ApplicationController
  layout 'admin'
  
  def index
    @list = 'index'
  end
  
end
