class Manage::ManageController < ApplicationController

  skip_before_filter :verify_authenticity_token

  Latest_Friend_Count   =  15

  Latest_Friend_FootStep = 20

  Lates_Photo_Count = 7

  layout "manage"

  before_filter :is_space_admin?
  
  before_filter :is_super_admin?,:only => :player_manage

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
    @my_photos = current_user.photos.find(:all,:limit => 3,:order => 'id desc')
    @blogs  = current_user.blogs.find(:all,:limit => 3,:order => 'id desc')
    @gifts  = current_user.receive_gifts.find(:all,:limit => 6,:order => 'id desc')
    @new_gifts_count = current_user.receive_gifts.count(:conditions => "created_at >= date_sub(now() , INTERVAL 1 day)")
    @new_regards_count = current_user.receive_gifts.count(:conditions => "created_at >= date_sub(now() , INTERVAL 1 day)")
    @visitores = current_user.visitors.find(:all,:limit => 12,:order => "id desc")
  end

  def player_manage
    conditions = params[:keywords].blank?  ? '' : ["real_name like ? or user_name like ?","%#{params[:keywords]}%","%#{params[:keywords]}%"]
    @players = Player.paginate(:page => params[:page]||1,:conditions => conditions,:order => 'id')
  end
  
  def update_player
    player = Player.find(params[:id])
    player.update_attributes(params[:player])
    render :update do |page|
      page.hide "vote_div_user#{player.id}"
      page.replace_html("vote_count_user#{player.id}", "<front style='color:red'>(#{player.vote_count})</front>")
    end
  end
  
end
