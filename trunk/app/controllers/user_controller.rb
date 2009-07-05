class UserController < ApplicationController
  
  layout 'site'
  
  skip_before_filter :verify_authenticity_token
  
#  before_filter :join_action

  def select
  end
  
  def signup
    @user = User.new(params[:user])
    @profile = UserProfile.new(params[:profile])
    @group = params[:group]    
    if request.method.to_s == 'post' &&  @user.save
      SidebarUser.create_default_sidebars(@user.id)
      BlogConfig.find_or_create_by_user_id(@user.id)
      @profile.user_id = @user.id
      if @profile.save  
        flash[:notice] = 'UserProfile was successfully created.'
        if !params[:forward].blank? && params[:forward] == 'join_active'
          session[:user] = @user
          redirect_to 'http://www.ccmw.net/active/join'
        else
          render :template => 'user/login'
        end
        return true
      end
    end
    render :template => "user/signup"
    return true
  end
  
  def login    
    # if get the login page, just render
    if request.method.to_s == 'get'
      render :layout => get_layout
      return true
    end
    # unless, the request is actually login
    session[:user] = params[:user].blank? ? nil : User.authenticate(params[:user][:user_name],params[:user][:password])
    if session[:user]
      flash[:message]  = "登陆成功"
      #redirect_to session[:return_to] || "/admin" 
      unless params[:admin].blank?
        redirect_to session[:return_to] || "/admin"
      else
        redirect_to session[:return_to] || params[:forward] || "/"
      end
    else
      flash[:warning] = "登陆失败，用户名或密码不对。若有问题，请发email到mucx@ccmw.net"
      render :layout => get_layout
    end    
  end
  
  def login_bar
    render :layout => 'login'
  end  

  def logout
    session[:user] = nil
    session[:return_to] = nil
    flash[:message] = 'Logged out'
    if params['page'] == 'index'
      redirect_to :controller => 'user', :action => 'login_bar'
    else
      redirect_to "http://www.#{Domain_Name}"
#      redirect_to :controller => 'user', :action => 'login'
    end
  end
  
  def forgot_password
    if request.post?
      if !params[:user].find{|key,value| value.blank?} &&  user = User.find(:first,:conditions => params[:user])
        CcmwMailer.deliver_send(user.email, user.password)
        render :text => "密码已发送到你注册邮箱，请查收"
        return
      end
      @user = User.new(params[:user])
      flash[:warning] = "信息不对，请重新输入"
    else
      @user = User.new
    end
    render :template => "/user/forget_password"
    return
  end


  def change_password
    @user=session[:user]
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:message]="Password Changed"
      end
    end
  end

  protected
  
  def get_layout
    params[:admin].blank? ? "site" : false
  end
  
end
