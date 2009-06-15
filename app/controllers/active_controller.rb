class ActiveController < ApplicationController
  
  before_filter :login_required, :only => [:take_part_in]
  before_filter :find_players, :only => [:active_news, :active_arrange, :active_player, :active_contact, :player_list, :comment_list, :blog_list, :search]
#  layout :active, :except => :to_vote
  skip_before_filter :verify_authenticity_token,:only => [:login, :logout, :search, :vote]  
  before_filter :set_statics_data
  
  before_filter  :set_ranking_list ,:only => [:index,:active_news,:arrange,:player]
  

  Player_Blog_Perpage     = 20
  Player_Photo_Perpage    = 20
  Player_Comments_Perpage = 5

  Player_Count_Perpage    = 16

  def index
    @blogs     =  Blog.find :all, :limit => 10
    @users     =  Player.find :all, :limit => Player_Count_Perpage,:order =>'id desc'
    @rand_users     =  Player.find :all, :limit => Player_Count_Perpage,:order =>'rand()'
    @comments  =  PlayerComment.find :all, :limit => 10    
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

  def post_vote        
    error_msg = ''
    if current_user
      if simple_captcha_valid?
        if ActiveVote.should_vote_agin?(request.remote_ip)
          active_vote = ActiveVote.new(params[:active_vote])
          active_vote.voter_id = current_user.id
          active_vote.ip     = request.remote_ip
          active_vote.save
        else
          error_msg = "30分钟后再来投票"
        end
      else
        error_msg  = '请输入正确验证码'
      end
    else
      error_msg  = '请登陆后再投'
    end
    unless error_msg.blank?
      render :update  do |page|
        page.replace_html "vote_notice",error_msg
        page.replace_html  'simple_captcha_td',:partial => '/active/simple_captcha'
      end
    else
      render :update  do |page|
        page.hide   "vote_div"
        page.replace_html  'simple_captcha_td',:partial => '/active/simple_captcha'
        page.replace_html 'vote_message',:partial => '/active/vote_message'
        page.alert  "投票成功，谢谢你的投票!"        
      end      
    end
    return true
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
  
  def active_news
  end  
  
  def active_arrange
  end
  
   def active_player
  end
  
    def active_contact
  end
  #查出所有的参与者分页显示
  def player_list
  end
  
  def vote
  end
  
  def search
    conditions = params[:q].blank? ? nil : "user_name LIKE '%#{params[:q]}%' or real_name LIKE '%#{params[:q]}%'"
    @search_users = Player.paginate(:page => params[:page]||1, :per_page => Player_Count_Perpage , :conditions => conditions, :order => 'created_at desc')
  end
  
  def blog_list
    @blogs = Blog.paginate(:page => params[:page]||1,:per_page => Player_Blog_Perpage ,:order => 'created_at desc')
  end
  
  def comment_list
    @comments = PlayerComment.paginate(:page => params[:page]||1,:per_page => Player_Comments_Perpage ,:order => 'created_at desc')
  end
 
  protected 
  
#  def active
#    return 'active'  
#  end
  
  def find_players
    @users = Player.paginate(:page => params[:page]||1,:per_page => Player_Count_Perpage ,:order => 'created_at desc')
    @focus_men = Player.paginate(:page => params[:page]||1,:per_page => Player_Count_Perpage ,:order => 'created_at desc')
  end
  
  def set_ranking_list
    @focus_men =  Player.find :all, :limit => Player_Count_Perpage,:order =>'rand()'
  end
  
  def set_statics_data
    @player_count = Player.count || 0
    @blog_count = Blog.count || 0
    @photo_count = Photo.count || 0
    @comment_count = PlayerComment.count || 0
    @vote_count = Vote.count ||0
    @day_hits = 0 #TODO how to get 
  end 
end
