class UserController < ApplicationController
  
  layout 'site'
  skip_before_filter :verify_authenticity_token
  
  def select
  end
  
  def signup
    @user = User.new(params[:user])
    @profile = UserProfile.new(params[:profile])
    @group = params[:group]
    return if generate_blank
    if @user.save  
      SidebarUser.create_default_sidebars(@user.id)
      BlogConfig.find_or_create_by_user_id(@user.id)
      @profile.user_id = @user.id
      if @profile.save  
        flash[:notice] = 'UserProfile was successfully created.'
        render :template => 'user/login'
        return true
      end
    end
    render :template => "user/signup"
    return true
  end
  
  def login
    # if get the login page, just render
    return if generate_blank

    # unless, the request is actually login
    session[:user] = params[:user].blank? ? nil : User.authenticate(params[:user][:user_name],params[:user][:password])
    if session[:user]
      flash[:message]  = "Login successful"
      #redirect_to session[:return_to] || "/admin" 
      unless params[:admin].blank?
        redirect_to session[:return_to] || "/admin"
      else
        redirect_to session[:return_to] || params[:forward] || "/"
      end
    else
      flash[:warning] = "Login unsuccessful"
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
    u= User.find_by_email(params[:user][:email])
    if u and u.send_new_password
      flash[:message]  = "A new password has been sent by email."
      redirect_to '/login'
    else
      flash[:warning]  = "Couldn't send password"
    end
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

  # Generate a template user for certain actions on get
  def generate_blank
    case request.method
    when :get
      @user = User.new
      render :layout => get_layout
      return true
    end
    return false
  end
  
  def get_layout
    params[:admin].blank? ? "site" : false
  end
  
end
