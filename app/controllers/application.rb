# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'auth/auth'
class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  before_filter :set_locale

  def set_locale
      # update session if passed
      session[:locale] = params[:locale] if params[:locale]
      session[:locale] = accepted_languages
      # set locale based on session or default
      I18n.locale = session[:locale] || I18n.default_locale
  end

  ##
  # Returns the languages accepted by the visitors, sorted by quality
  # (order of preference).
  ##
  def accepted_languages()
    # no language accepted
    return [] if request.env["HTTP_ACCEPT_LANGUAGE"].nil?
    
    # parse Accept-Language
    accepted = request.env["HTTP_ACCEPT_LANGUAGE"].split(",")
    accepted = accepted.map { |l| l.strip.split(";") }
    accepted = accepted.map { |l|
      if (l.size == 2)
        # quality present
        #[ l[0].split("-")[0].downcase, l[1].sub(/^q=/, "").to_f ]
      else
        # no quality specified =&gt; quality == 1
        #[ l[0].split("-")[0].downcase, 1.0 ]
        ll = l[0].split("-")
        if (ll.size > 1)
          [ll[0], ll[1].upcase]
        else
          []
        end
      end
    }
    accepted[0].join("-")
  end
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '753e9f8530306cea8709833fd5983953'

   
  include Auth
 
  protected
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
    login_url = "/user/login"
    login_url = "#{login_url}?admin=true" if session[:return_to].index('admin')
    redirect_to login_url
  end
 
end
