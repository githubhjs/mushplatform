class Manage::ManageController < ApplicationController
  skip_before_filter :verify_authenticity_token

  layout "space"

  before_filter :is_space_admin?
  
  def index
    
  end
  
end
