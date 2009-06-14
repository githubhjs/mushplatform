class ActiveController < ApplicationController
  
  before_filter :login_required, :only => [:take_part_in]

  before_filter  :set_ranking_list ,:only => [:index,:active_news,:arrange,:player]
  
  Player_Blog_Perpage     = 20
  Player_Photo_Perpage    = 20
  Player_Comments_Perpage = 5

  Player_Count_Perpage    = 16

  def index    
    @blogs     =  Blog.find :all, :limit => 10
    @users     =  Player.find :all, :limit => Player_Count_Perpage,:order =>'id desc'
    @rand_users     =  Player.find :all, :limit => Player_Count_Perpage,:order =>'rand()'
    @comments  =  Comment.find :all, :limit => 10    
  end  
  
  def active_news
    
  end  
  
  def arrange
    
  end
  
  #  @blogs = Blog.find :all, :conditions => "user_id = #{current_user.id}" ,:limit => 10
  #  @focus_men = User.find :all, :limit => 10
  def take_part_in
    unless Player.find_by_user_id(current_user.id).nil?
      render :template => '/active/already_join'
      return
    end
    player = Player.new(:user_id => current_user.id,:user_name => current_user.user_name,
      :real_name => current_user.real_name)
    player.blog_count = current_user.blogs.count
    player.photo_count = current_user.photos.count
    player.save
    redirect_to player.player_url
  end   
  
  def player
    @user = Player.find_by_user_name(params[:user_name])
    if @user.nil?
      render :template => '/active/not_join'
      return
    end
    @blogs  = Blog.find(:all,:conditions => "user_id=#{@user.user_id}" ,:order => 'id desc',:limit => Player_Blog_Perpage )
    @photos = Photo.find(:all,:conditions => "user_id=#{@user.user_id}" ,:order => 'id desc',:limit => Player_Photo_Perpage )
    @comments = PlayerComment.find(:all,:conditions => "player_id=#{@user.user_id}",:order => 'id desc',:limit => Player_Comments_Perpage)
    @ranking = Player.count(:conditions => "vote_count>#{@user.vote_count}") + 1
  end

  def comment    
    if user = (current_user || (params[:user] && User.authenticate(params[:user][:user_name],params[:user][:password])))
      @comment = PlayerComment.new(params[:comment])
      @comment.user_id = user.id
      @comment.user_name = user.user_name
      @comment.real_name = user.real_name
      if @comment.save
        Player.connection.execute("update players set comment_count = comment_count + 1 where id=#{@comment.player_id}")
        render :update do |page|
          page.insert_html :bottom, 'comments',:partial => "/active/comment_list",:locals => {:comment => @comment }
        end
      else
        render :update do |page|
          page.replace_html 'erro_info',@comment.errors.full_messages.join(';')
          page['erro_info'].show
        end
      end
    else
      render :update do |page|
        page.replace_html 'erro_info', "没有登陆或者用户名或和密码不对"
        page['erro_info'].show
      end
    end
  end

  def login    
    session[:user] = params[:user].blank? ? nil : User.authenticate(params[:user][:user_name],params[:user][:password])
    if session[:user]
      render :update do |page|
        page.replace_html 'login_bar_div', :partial => "/active/login_info"
      end
    else
      render :update do |page|
        page.replace_html 'login_info', "用户名或密码不对"
      end
    end    
  end

  def logout
    session[:user] = nil
    render :update do |page|
      page.replace_html 'login_bar_div', :partial => "/active/login_bar"
    end
  end
  
  protected
  def set_ranking_list    
    @focus_men =  Player.find :all, :limit => 16,:order =>'rand()'
  end

end
