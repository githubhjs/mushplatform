class ActiveController < ApplicationController
  
  before_filter :login_required, :only => [:take_part_in]
  before_filter :find_players, :only => [:index, :player, :active_news, :active_arrange, :active_player, :active_contact, :comment_list, :blog_list, :search, :active_gold]
  skip_before_filter :verify_authenticity_token,:only => [:login, :logout, :search, :simple_vote]  
  before_filter :set_statics_data, :except => [:simple_vote, :post_vote,:login]
  
  before_filter  :set_ranking_list ,:only => [:index,:active_news,:active_arrange,:active_player,:player,:active_glod]
  

  Player_Blog_Perpage     = 20
  Player_Photo_Perpage    = 20
  Player_Comments_Perpage = 10

  Player_Count_Perpage    = 16
  Player_Count_List = 10

  def index
    @blogs     =  Blog.paginate :page => params[:page]||1,:per_page => 10,:conditions =>"user_id in (select user_id from players)",:order => 'id desc'
    @users     =  Player.find :all, :limit => Player_Count_Perpage,:order =>'id desc'
    @rand_users     =  Player.find :all, :limit => Player_Count_Perpage,:order =>'rand()'    
    @comments  =  PlayerComment.paginate :page => params[:page],:per_page =>Player_Comments_Perpage,:order => 'id desc'    
    @articles  = Article.find(:all,:conditions => "channel_id=16",:order => 'top desc,id desc',:limit => 10)
    @rule_articles  = Article.find(:all,:conditions => "channel_id=17",:order => 'top desc,id desc',:limit => 10)
  end  
  
  def take_part_in
    unless Player.find_by_user_id(current_user.id).nil?
      render :template => '/active/already_join'
      return
    end
    player = Player.new(:user_id => current_user.id,:user_name => current_user.user_name,
      :real_name => current_user.real_name)
    player.blog_count  = current_user.blogs.count
    player.photo_count = current_user.photos.count
    player.user_type   = current_user.user_type
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
    error_msg = simple_captcha_valid? ?
      ( ActiveVote.should_vote_agin?(request.remote_ip,params[:active_vote][:user_id])  ?  nil :  '30分钟后再来投票') :
      '请输入正确验证码'      
    if error_msg.nil?
      active_vote     =  ActiveVote.new(params[:active_vote])
      active_vote.ip  =  request.remote_ip
      active_vote.save
    end
    id_buffix = ((params[:user_id].blank? || params[:location].blank?) ? '' : "_#{params[:location]}_#{params[:user_id]}")
    render :update  do |page|      
#      page.replace_html  "simple_captcha_td#{id_buffix}",:partial => '/active/simple_captcha'
      page.replace_html  "simple_only_captcha_div",:partial => '/active/simple_captcha'
      unless error_msg.blank?
        page.replace_html "vote_notice#{id_buffix}",error_msg
        page.replace_html  "simple_captcha_td#{id_buffix}",:partial => '/active/simple_captcha'
        page.call(:replaceVoteCaptcha,"simple_captcha_td#{id_buffix}")
      else
        page.hide   "vote_div#{id_buffix}"
        page.replace_html "vote_message#{id_buffix}",''
        page.alert  "投票成功，谢谢你的投票!"        
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
  
  def active_news
     @articles  = Article.find(:all,:conditions => "channel_id=16",:order => 'top desc,id desc')
  end  
  
  def active_arrange
  end
  
  def active_player
    @rand_users     =  Player.find :all, :limit => Player_Count_Perpage,:order =>'rand()'
  end
  
  def active_contact
  end
  
  def active_gold
  end
  
  def search
    if params[:q].blank?
      redirect_to :action => 'index'
      return true
    end
    user_type = params[:user_type].blank? ? 0 : params[:user_type]
    conditions = ["user_type=#{user_type} and user_name LIKE ? or real_name LIKE ?","%#{params[:q]}%","%#{params[:q]}%"]    
    @search_users = Player.paginate(:page => params[:page], :per_page => Player_Count_Perpage , :conditions => conditions, :order => 'id desc')
  end
  
  def blog_list
    @blogs = Blog.paginate(:page => params[:page],:per_page => Player_Blog_Perpage ,:order => 'created_at desc')
  end
  
  def comment_list
    conditions = params[:user_id].blank? ? '' : "player_id=#{params[:user_id]}"
    @comments = PlayerComment.paginate(:page => params[:page],:per_page =>Player_Comments_Perpage,
      :conditions => conditions,:order => 'created_at desc')
  end
  
  
  protected 
  #TODO
  def find_players
    #left
    @new_entry = Player.find :all, :limit => Player_Count_Perpage, :order => 'created_at desc'
    @users = Player.paginate(:page => params[:page]||1,:per_page => Player_Count_Perpage ,:order => 'created_at desc')
    #top
    @personals = Player.find :all, :limit => Player_Count_List,:conditions => "user_type=0",:order => 'vote_count  desc'
    @teams_players = Player.find :all, :limit => Player_Count_List,:conditions => "user_type=1" ,:order => 'vote_count  desc'
    @student_players = Player.find :all, :limit => Player_Count_List,:conditions => "user_type=2" ,:order => 'vote_count  desc'
    @week_men = Player.find :all, :conditions => "created_at >= date_sub(NOW(),interval 7 day)" ,:limit => Player_Count_List, :order => 'created_at, vote_count  desc'
    @month_men = Player.find :all, :conditions => "created_at >= date_sub(NOW(),interval 30 day)", :limit => Player_Count_List, :order => 'created_at, vote_count desc'
  end
  
  def set_ranking_list
    @focus_men =  Player.find :all, :limit => Player_Count_Perpage,:order =>'rand()'
  end
  
  def set_statics_data
    @player_count = Player.count || 0
    @blog_count = Blog.count || 0
    @photo_count = Photo.count || 0
    @comment_count = PlayerComment.count || 0
    @vote_count = ActiveVote.count ||0
    @day_hits = 0 #TODO how to get 
  end
  
end
#def simple_vote
#    error_msg = ''
#    #    if current_user
#    if ActiveVote.should_vote_agin?(request.remote_ip,params[:user_id])
#      user = Player.find_by_user_id(params[:user_id])
#      active_vote = ActiveVote.new
#      active_vote.user_id = user.user_id
#      #        active_vote.voter_id = current_user.id
#      active_vote.user_name = user.real_name
#      active_vote.ip = request.remote_ip
#      error_msg = "" if active_vote.save
#    else
#      error_msg = "30分钟后再来投票"
#    end
#    #    else
#    #      error_msg  = '请登陆后再投'
#    #    end
#    if error_msg.blank?
#      render :update  do |page|
#        page.alert  "投票成功，谢谢你的投票!"
#      end
#    else
#      render :update  do |page|
#        page.alert error_msg
#      end
#    end
#  end
#