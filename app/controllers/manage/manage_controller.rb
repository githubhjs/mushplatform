class Manage::ManageController < ApplicationController

  layout "space"

  before_filter :is_space_admin?
  
  def index
    
  end
  
end
