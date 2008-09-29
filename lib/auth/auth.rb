module Auth
  
  def login_required(admin=nil)
    if session[:user]
      return true
    end
    flash[:warning]='Please login to continue'
    session[:return_to] = request.request_uri
    redirect_to "/login"
    return false 
  end
  
  def current_user
    session[:user]
  end 
  
  def is_space_admin?
    unless  current_user #&& current_user.user_name == request.subdomains.first
      flash[:warning]='Please login to continue'
      session[:return_to] = request.request_uri
      redirect_to "/login"
      return false
    end
    return true
  end
  
end
