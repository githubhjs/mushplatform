class SignupController < ApplicationController
  
  layout 'site'
  
  def index
    @user = User.new
    @profile = UserProfile.new
  end
  
  def create
    @user = User.new(params[:user])
    @profile = UserProfile.new(params[:profile])
    if @user.save  
      @profile.user_id = @user.id
      if @profile.save  
        flash[:notice] = 'UserProfile was successfully created.'
        render :template => '/signup/login'
        return true
      end
    end
    render :template => "/signup/index"
    return true
  end
  
  def login
    unless request.post?
      render :template => '/signup/login'
      retun true
    end
    session[:user] = User.authenticate(params[:user][:user_name],params[:user][:password])
    if session[:user]
      flash[:message]  = "Login successful"
      render :text => "Login successful"
    else
      flash[:warning] = "Login unsuccessful"
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'login'
  end
  
  def forgot_password
    u= User.find_by_email(params[:user][:email])
    if u and u.send_new_password
      flash[:message]  = "A new password has been sent by email."
      redirect_to :action=>'login'
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
  
end
