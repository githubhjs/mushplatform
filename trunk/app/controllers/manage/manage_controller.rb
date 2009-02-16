class Manage::ManageController < ApplicationController

  skip_before_filter :verify_authenticity_token

  Latest_Friend_Count = 4

  layout "space"

  before_filter :is_space_admin?


  def index
    @friends = current_user.friends.find(:all,:limit => Latest_Friend_Count,:order => 'friends.created_at desc')
  end
  
end
