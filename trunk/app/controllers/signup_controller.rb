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
        render :template => '/login/login'
        return true
      end
    end
    render :template => "/signup/index"
    return true
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
  
end
