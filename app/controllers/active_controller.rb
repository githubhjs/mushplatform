class ActiveController < ApplicationController
  
  before_filter :login_required, :only => [:take_part_in]
  
  
  def index
    
    @blogs = Blog.find :all, :limit => 10
    @comments = Comment.find :all, :limit => 10
    @users = User.find :all, :limit => 10    
    @focus_men = User.find :all, :limit => 10
    
  end  
  
  def active_news
    
  end  
  
  def arrange
    
  end
  
  def take_part_in
    @blogs = Blog.find :all, :conditions => "user_id = #{current_user.id}" ,:limit => 10
    @focus_men = User.find :all, :limit => 10
  end
  
  def login    
    session[:user] = params[:user].blank? ? nil : User.authenticate(params[:user][:user_name],params[:user][:password])
    if session[:user]
      render :update do |page|
        page.replace_html 'login_bar_div', :partial => "/active/login_info"
      end
    else
      render :update do |page|
        page.replace_html 'login_info', "用户名或密码不对"
      end
    end
  end

  def logout
    debugger
    session[:user] = nil
    render :update do |page|
      page.replace_html 'login_bar_div', :partial => "/active/login_bar"
    end
  end
  
end
