class LoginController < ApplicationController

  layout  "site"
  
  skip_before_filter :verify_authenticity_token,:only => [:sign_up]
  
  def login
    render :template => 'login/login', :layout => get_layout
    return "site"
  end
  
  def sign_up
    debugger
    session[:user] = params[:user].blank? ? nil : User.authenticate(params[:user][:user_name],params[:user][:password])
    if session[:user]
      flash[:message]  = "Login successful"
      #redirect_to session[:return_to] || "/admin" 
      unless params[:admin].blank?
        redirect_to session[:return_to] || "/admin"
      else
        redirect_to session[:return_to] || params[:forward] || "/manage"
      end
      
    else
      flash[:warning] = "Login unsuccessful"
      render :template => 'login/login', :layout => get_layout
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    render :template => 'login/login', :layout => get_layout
  end

  def get_layout
    params[:admin].blank? ? "site" : false
  end
  
end
