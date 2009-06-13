class VipController < ApplicationController
  layout :active
  
  def index
    @blog = Blog.find :all, :limit => 10 
    @comments = Comment.find :all, :limit => 10
    @users = User.find :all, :limit => 10
    
    @focus_men = User.find :all, :limit => 10
    
    @user = User.find(params[:user_id])
  end
  #进入参赛选手的blog
  def entry_blog
      
  end
  
  
  def active
    return 'active'  
  end
end
