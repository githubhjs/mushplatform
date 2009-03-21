class Manage::ManageController < ApplicationController

  skip_before_filter :verify_authenticity_token

  Latest_Friend_Count   =  15

  Latest_Friend_FootStep = 20

  Lates_Photo_Count = 7

  layout "manage"

  before_filter :is_space_admin?

  def index    
    @friends = current_user.friends.find(:all,:limit => Latest_Friend_Count,:order => 'friends.created_at desc')
    @photos = if @friends.blank?
      []
    else
      Photo.find(:all,:limit => Lates_Photo_Count,:conditions => "user_id in (#{current_user.friends.map(&:friend_id).join(',')})",:order => 'id desc')
    end
    @footsteps = if @friends.blank?
      []
    else
      Footstep.find(:all,:limit => Latest_Friend_FootStep,:order => 'created_at desc,app',
      :conditions => "user_id in (#{current_user.friends.map(&:friend_id).join(',')})")
    end
    @my_photos = current_user.photos.find(:all,:limit => 3,:order => 'id')
    @blogs  = current_user.blogs.find(:all,:limit => 3,:order => 'comment_count desc,view_count desc,id')
    @gifts  = current_user.receive_gifts.find(:all,:limit => 6,:order => 'id')
    @new_gifts_count = current_user.receive_gifts.count(:conditions => "created_at >= date_sub(now() , INTERVAL 1 day)")
    @new_regards_count = current_user.receive_gifts.count(:conditions => "created_at >= date_sub(now() , INTERVAL 1 day)")
    @visitores = current_user.visitors.find(:all,:limit => 12,:order => "id desc")
  end
  
end
