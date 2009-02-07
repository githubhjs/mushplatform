module Auth

  protected  
  def login_required(admin=nil)
    if session[:user]
      return true
    end
    flash[:warning]='Please login to continue'
    session[:return_to] = request.request_uri
    redirect_to "/user/login"
    return false 
  end
  
  def current_user
    session[:user]
  end 
  
  def is_blog_admin?
    current_user && current_user.user_name == request.subdomains.first
  end

  def is_friend_with_blog_admin?
    !is_blog_admin? && blog_owner.is_friend_with?(current_user)
  end

  def blog_owner
    @blog_owner ||= User.find_by_user_name(request.subdomains.first)
  end

  def is_space_admin?
    unless  current_user && current_user.user_name == request.subdomains.first
      flash[:warning]='Please login to continue'
      session[:return_to] = request.request_uri
      redirect_to "/user/login"
      return false
    end
    return true
  end
  
end
