class LoginController < ApplicationController
  layout "site"
  def login
    unless request.post?
      render :template => '/login/login'
      return true
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
  
end
