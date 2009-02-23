class Manage::ManageController < ApplicationController

  skip_before_filter :verify_authenticity_token

  Latest_Friend_Count   =  4

  Latest_Friend_FootStep = 20

  layout "space"

  before_filter :is_space_admin?


  def index
    @friends = current_user.friends.find(:all,:limit => Latest_Friend_Count,:order => 'friends.created_at desc')
    @footsteps = if @friends.blank?
      []
    else
      Footstep.find(:all,:limit => Latest_Friend_FootStep,:order => 'created_at desc,app',
    :conditions => "user_id in (#{current_user.friends.map(&:friend_id).join(',')})")
    end
      
  end
  
end
