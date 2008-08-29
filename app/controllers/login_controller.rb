class LoginController < ApplicationController
  layout "site"
  def login
    unless request.post?
      render :template => 'login/login', :layout => (params[:admin] ? false : true)
      return true
    end
    session[:user] = User.authenticate(params[:user][:user_name],params[:user][:password])
    if session[:user]
      flash[:message]  = "Login successful"
#      render :text => "Login successful" 
      redirect_to session[:return_to]
    else
      flash[:warning] = "Login unsuccessful"
      render :template => 'login/login', :layout => (params[:admin] ? false : true)
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    render :template => 'login/login', :layout => (params[:admin] ? false : true)
  end
  
end
