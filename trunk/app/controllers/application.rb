# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'auth/auth'
class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '753e9f8530306cea8709833fd5983953'
  
  include AccountLocation
  include Auth
  
  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller=>'user', :action=>'welcome'
    end
  end
  
  def permission_denied
    flash[:error] = "Plase login"
    session[:return_to]=request.request_uri
    login_url = "/login"
    login_url = "#{login_url}?admin=true" if session[:return_to].index('admin')
    redirect_to login_url
  end
  
end